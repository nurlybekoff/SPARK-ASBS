--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Monitors the pilot's control levers for the aircraft's
--                      thrust reversers and ground spoilers. In addition, manages
--                      the safe-braking mode and sensor (speed/pressure) alarm states.

pragma SPARK_Mode (On);
package body PCU
is

   procedure RequestDeployThrustReversers is
   begin
      ThrustReverseLeverPos := REVE;
   end RequestDeployThrustReversers;

   procedure RequestStowThrustReversers is
   begin
      ThrustReverseLeverPos := FORW;
   end RequestStowThrustReversers;

   function isRequestedDeployThrustReversers return Boolean is
   begin
      return ThrustReverseLeverPos = REVE;
   end isRequestedDeployThrustReversers;

   procedure RequestExtendGroundSpoilers is
   begin
      GroundSpoilerLeverPos := REVE;
   end RequestExtendGroundSpoilers;

   procedure RequestRetractGroundSpoilers is
   begin
      GroundSpoilerLeverPos := FORW;
   end RequestRetractGroundSpoilers;

   function isRequestedExtendGroundSpoilers return Boolean is
   begin
      return GroundSpoilerLeverPos = REVE;
   end isRequestedExtendGroundSpoilers;

   procedure EnableSafeBrakingMode is
   begin
      SafeBrakingModeEnabled := True;
   end EnableSafeBrakingMode;

   procedure DisableSafeBrakingMode is
   begin
      SafeBrakingModeEnabled := False;
   end DisableSafeBrakingMode;

   function isEnablededSafeBrakingMode return Boolean is
   begin
      return SafeBrakingModeEnabled;
   end isEnablededSafeBrakingMode;

   procedure EnableSensorAlarm is
   begin
      SensorAlarmON := True;
   end EnableSensorAlarm;

   procedure DisableSensorAlarm is
   begin
      SensorAlarmON := False;
   end DisableSensorAlarm;

   function isEnabledSensorAlarm return Boolean is
   begin
      return SensorAlarmON;
   end isEnabledSensorAlarm;

begin
   ThrustReverseLeverPos  := FORW;
   GroundSpoilerLeverPos  := FORW;
   SafeBrakingModeEnabled := False;
   SensorAlarmON          := False;
end PCU;
