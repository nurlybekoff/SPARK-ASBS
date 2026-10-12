--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Monitors the pilot's control levers for the aircraft's 
--                      thrust reversers and ground spoilers. In addition, manages 
--                      the safe-braking mode and sensor (speed/pressure) alarm states.  

pragma SPARK_Mode (On); 
package  PCU

is
   pragma Elaborate_Body; 

   type Position  is (FORW, REVE); -- lever positions are FORWard or REVEerse 
      
   ThrustReverseLeverPos:  Position;  -- Position of the thrust reversers lever. 
   GroundSpoilerLeverPos:  Position;  -- Position of the ground spoilers lever. 
   SafeBrakingModeEnabled: Boolean;   -- Safe-braking mode state.
   SensorAlarmON:          Boolean;   -- Speed and pressure alarm state.
   
   -- Deploy: Thrust reversers lever pulled back into reverse position.
   procedure RequestDeployThrustReversers
   with
     Global  => (Output => ThrustReverseLeverPos),
     Depends => (ThrustReverseLeverPos => null),
     Pre     => True,
     Post    => ThrustReverseLeverPos = REVE;

   -- Stow: Thrust reversers lever pushed into the forward position.
   procedure RequestStowThrustReversers
   with
     Global  => (Output   => ThrustReverseLeverPos),
     Depends => (ThrustReverseLeverPos => null),
     Pre     => True,
     Post    => ThrustReverseLeverPos = FORW;

   -- Returns True when thrust reversers lever in REVE position; otherwise False.
   function isRequestedDeployThrustReversers return Boolean
     with
       Global  => (Input   => ThrustReverseLeverPos),
       Depends => (isRequestedDeployThrustReversers'Result =>
                                         ThrustReverseLeverPos),
       Pre     => True,
       Post    => isRequestedDeployThrustReversers'Result =
                    (ThrustReverseLeverPos = REVE);

   -- Extend: Ground spoilers lever pulled back into reverse position.
   procedure RequestExtendGroundSpoilers
   with
     Global  => (Output   => GroundSpoilerLeverPos),
     Depends => (GroundSpoilerLeverPos => null),
     Pre     => True,
     Post    => GroundSpoilerLeverPos = REVE;

   -- Retract: Ground spoilers lever pushed into the forward position.
   procedure RequestRetractGroundSpoilers
   with
     Global  => (Output => GroundSpoilerLeverPos),
     Depends => (GroundSpoilerLeverPos => null),
     Pre     => True,
     Post    => GroundSpoilerLeverPos = FORW;

   -- Returns True when ground spoiler lever in REVE position; otherwise False.
   function isRequestedExtendGroundSpoilers return Boolean
     with
       Global  => (Input   => GroundSpoilerLeverPos),
       Depends => (isRequestedExtendGroundSpoilers'Result =>
                                         GroundSpoilerLeverPos),
       Pre     => True,
       Post    => isRequestedExtendGroundSpoilers'Result =
                    (GroundSpoilerLeverPos = REVE);

   -- Enable safe-braking mode.
   procedure EnableSafeBrakingMode
   with
     Global  => (Output => SafeBrakingModeEnabled),
     Depends => (SafeBrakingModeEnabled => null),
     Pre     => True,
     Post    => SafeBrakingModeEnabled;

   -- Disable safe-braking mode.
   procedure DisableSafeBrakingMode
   with
     Global  => (Output => SafeBrakingModeEnabled),
     Depends => (SafeBrakingModeEnabled => null),
     Pre     => True,
     Post    => not SafeBrakingModeEnabled;

   -- Returns True when safe-braking mode enabled; otherwise False.
   function isEnablededSafeBrakingMode return Boolean
     with
       Global  => (Input   => SafeBrakingModeEnabled),
       Depends => (isEnablededSafeBrakingMode'Result => SafeBrakingModeEnabled),
       Pre     => True,
       Post    => isEnablededSafeBrakingMode'Result = SafeBrakingModeEnabled;

   -- Enable sensor (speed/pressure) alarm.
   procedure EnableSensorAlarm
   with
     Global  => (Output => SensorAlarmON),
     Depends => (SensorAlarmON => null),
     Pre     => True,
     Post    => SensorAlarmON;

   -- Disable sensor (speed/pressure) alarm.
   procedure DisableSensorAlarm
   with
     Global  => (Output => SensorAlarmON),
     Depends => (SensorAlarmON => null),
     Pre     => True,
     Post    => not SensorAlarmON;

   -- Returns True when sensor (speed/pressure) alarm enabled; otherwise False.
   function isEnabledSensorAlarm return Boolean
     with
       Global  => (Input   => SensorAlarmON),
       Depends => (isEnabledSensorAlarm'Result => SensorAlarmON),
       Pre     => True,
       Post    => isEnabledSensorAlarm'Result = SensorAlarmON;
  
end PCU;



