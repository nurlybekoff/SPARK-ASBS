--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Braking System Control Unit.

pragma SPARK_Mode (On);
package body BSCU
is

   procedure Controller is
      SBM      : constant Boolean := PCU.isEnablededSafeBrakingMode;
      Request_TR : constant Boolean := PCU.isRequestedDeployThrustReversers;
      Request_GS : constant Boolean := PCU.isRequestedExtendGroundSpoilers;
      Was_TR   : constant Boolean := BSU.isDeployedThrustReversers;
      Was_GS   : constant Boolean := BSU.isExtendedGroundSpoilers;
   begin
      if not SBM then
         Consecutive_Low_Speed_Readings := 0;
         PCU.DisableSensorAlarm;

         if Request_TR then
            BSU.DeployThrustReversers;
         else
            BSU.StowThrustReversers;
         end if;

         if Request_GS then
            BSU.ExtendGroundSpoilers;
         else
            BSU.RetractGroundSpoilers;
         end if;
      else
         if Majority_Is_Low_Speed then
            if Consecutive_Low_Speed_Readings < 2 then
               Consecutive_Low_Speed_Readings :=
                 Consecutive_Low_Speed_Readings + 1;
            end if;
         else
            Consecutive_Low_Speed_Readings := 0;
         end if;

         if Sensor_Error then
            PCU.EnableSensorAlarm;
         else
            PCU.DisableSensorAlarm;
         end if;

         if Request_TR then
            if Was_TR or else Both_MLG_Loaded then
               BSU.DeployThrustReversers;
            else
               BSU.StowThrustReversers;
            end if;
         else
            if Was_TR and then Consecutive_Low_Speed_Readings < 2 then
               BSU.DeployThrustReversers;
            else
               BSU.StowThrustReversers;
            end if;
         end if;

         if Request_GS then
            if Was_GS or else GS_Extend_Permitted then
               BSU.ExtendGroundSpoilers;
            else
               BSU.RetractGroundSpoilers;
            end if;
         else
            if Was_GS and then Consecutive_Low_Speed_Readings < 2 then
               BSU.ExtendGroundSpoilers;
            else
               BSU.RetractGroundSpoilers;
            end if;
         end if;
      end if;
   end Controller;

end BSCU;
