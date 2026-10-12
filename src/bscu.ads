--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Braking System Control Unit. Moderates pilot requests
--                      for thrust reversers and ground spoilers while
--                      safe-braking mode is enabled, and follows the pilot
--                      unmoderated when it is disabled.

pragma SPARK_Mode (On);
with LGU, BSU, PCU;
package BSCU
is
   pragma Unevaluated_Use_Of_Old (Allow);

   Min_MLG_Load          : constant LGU.Load_Sensor_Type := 6;
   GS_Speed_Threshold    : constant LGU.Speed_Type       := 83;
   Low_Speed_Threshold   : constant LGU.Speed_Type       := 60;

   subtype Low_Speed_Count_Type is Integer range 0 .. 2;

   -- Consecutive majority wheel-speed readings in 0 .. Low_Speed_Threshold.
   Consecutive_Low_Speed_Readings : Low_Speed_Count_Type := 0;

   function Both_MLG_Loaded return Boolean is
     (LGU.Read_LoadSensor (1) >= Min_MLG_Load
      and then LGU.Read_LoadSensor (2) >= Min_MLG_Load)
   with
     Global  => (Input => LGU.LoadSensorsState),
     Depends => (Both_MLG_Loaded'Result => LGU.LoadSensorsState),
     Pre     => True,
     Post    => Both_MLG_Loaded'Result =
                  (LGU.Read_LoadSensor (1) >= Min_MLG_Load
                   and then LGU.Read_LoadSensor (2) >= Min_MLG_Load);

   function Majority_Exceeds_GS_Threshold return Boolean is
     (LGU.Read_SpeedSensor_Majority > GS_Speed_Threshold)
   with
     Global  => (Input => LGU.SpeedSensorsState),
     Depends => (Majority_Exceeds_GS_Threshold'Result => LGU.SpeedSensorsState),
     Pre     => True,
     Post    => Majority_Exceeds_GS_Threshold'Result =
                  (LGU.Read_SpeedSensor_Majority > GS_Speed_Threshold);

   function GS_Extend_Permitted return Boolean is
     (Both_MLG_Loaded or else Majority_Exceeds_GS_Threshold)
   with
     Global  => (Input => (LGU.LoadSensorsState, LGU.SpeedSensorsState)),
     Depends => (GS_Extend_Permitted'Result =>
                   (LGU.LoadSensorsState, LGU.SpeedSensorsState)),
     Pre     => True,
     Post    => GS_Extend_Permitted'Result =
                  (Both_MLG_Loaded or else Majority_Exceeds_GS_Threshold);

   function Majority_Is_Low_Speed return Boolean is
     (LGU.Read_SpeedSensor_Majority >= 0
      and then LGU.Read_SpeedSensor_Majority <= Low_Speed_Threshold)
   with
     Global  => (Input => LGU.SpeedSensorsState),
     Depends => (Majority_Is_Low_Speed'Result => LGU.SpeedSensorsState),
     Pre     => True,
     Post    => Majority_Is_Low_Speed'Result =
                  (LGU.Read_SpeedSensor_Majority >= 0
                   and then LGU.Read_SpeedSensor_Majority <= Low_Speed_Threshold);

   function Sensor_Error return Boolean is
     (LGU.Read_SpeedSensor_Majority = LGU.Err_Value
      or else LGU.Read_LoadSensor (1) < 0
      or else LGU.Read_LoadSensor (2) < 0)
   with
     Global  => (Input => (LGU.SpeedSensorsState, LGU.LoadSensorsState)),
     Depends => (Sensor_Error'Result =>
                   (LGU.SpeedSensorsState, LGU.LoadSensorsState)),
     Pre     => True,
     Post    => Sensor_Error'Result =
                  (LGU.Read_SpeedSensor_Majority = LGU.Err_Value
                   or else LGU.Read_LoadSensor (1) < 0
                   or else LGU.Read_LoadSensor (2) < 0);

   procedure Controller
   with
     Global  =>
       (Input  => (LGU.SpeedSensorsState,
                   LGU.LoadSensorsState,
                   PCU.ThrustReverseLeverPos,
                   PCU.GroundSpoilerLeverPos,
                   PCU.SafeBrakingModeEnabled),
        In_Out => (BSU.ThrustReversersDeployed,
                   BSU.GroundSpoilersExtended,
                   Consecutive_Low_Speed_Readings),
        Output => PCU.SensorAlarmON),
     Depends =>
       (BSU.ThrustReversersDeployed =>
          (BSU.ThrustReversersDeployed,
           PCU.SafeBrakingModeEnabled,
           PCU.ThrustReverseLeverPos,
           LGU.LoadSensorsState,
           LGU.SpeedSensorsState,
           Consecutive_Low_Speed_Readings),
        BSU.GroundSpoilersExtended =>
          (BSU.GroundSpoilersExtended,
           PCU.SafeBrakingModeEnabled,
           PCU.GroundSpoilerLeverPos,
           LGU.LoadSensorsState,
           LGU.SpeedSensorsState,
           Consecutive_Low_Speed_Readings),
        Consecutive_Low_Speed_Readings =>
          (Consecutive_Low_Speed_Readings,
           PCU.SafeBrakingModeEnabled,
           LGU.SpeedSensorsState),
        PCU.SensorAlarmON =>
          (PCU.SafeBrakingModeEnabled,
           LGU.SpeedSensorsState,
           LGU.LoadSensorsState)),
     Pre  => True,
     Post =>
       (if not PCU.isEnablededSafeBrakingMode then
          BSU.ThrustReversersDeployed = PCU.isRequestedDeployThrustReversers
          and then BSU.GroundSpoilersExtended =
                     PCU.isRequestedExtendGroundSpoilers
          and then not PCU.isEnabledSensorAlarm
          and then Consecutive_Low_Speed_Readings = 0
        else
          PCU.isEnabledSensorAlarm = Sensor_Error
          and then
          (if Majority_Is_Low_Speed then
             (if Consecutive_Low_Speed_Readings'Old = 2 then
                Consecutive_Low_Speed_Readings = 2
              else
                Consecutive_Low_Speed_Readings =
                  Consecutive_Low_Speed_Readings'Old + 1)
           else
             Consecutive_Low_Speed_Readings = 0)
          -- SC-1: safe deployment of thrust reversers
          and then
          (if BSU.ThrustReversersDeployed
              and then not BSU.ThrustReversersDeployed'Old
           then
              PCU.isRequestedDeployThrustReversers
              and then Both_MLG_Loaded)
          -- SC-2: safe stowing of thrust reversers
          -- (disc-brakes suffice once speed is <= 60 mph for two readings)
          and then
          (if not BSU.ThrustReversersDeployed
              and then BSU.ThrustReversersDeployed'Old
           then
              not PCU.isRequestedDeployThrustReversers
              and then Majority_Is_Low_Speed
              and then Consecutive_Low_Speed_Readings >= 2)
          -- SC-3: safe extension of ground spoilers
          and then
          (if BSU.GroundSpoilersExtended
              and then not BSU.GroundSpoilersExtended'Old
           then
              PCU.isRequestedExtendGroundSpoilers
              and then GS_Extend_Permitted)
          -- SC-4: safe retraction of ground spoilers
          and then
          (if not BSU.GroundSpoilersExtended
              and then BSU.GroundSpoilersExtended'Old
           then
              not PCU.isRequestedExtendGroundSpoilers
              and then Majority_Is_Low_Speed
              and then Consecutive_Low_Speed_Readings >= 2));

end BSCU;
