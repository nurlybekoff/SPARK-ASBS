
-- Author:              A. Ireland
--
-- Address:             School Mathematical & Computer Sciences
--                      Heriot-Watt University
--                      Edinburgh, EH14 4AS
--
-- E-mail:              a.ireland@hw.ac.uk
--
-- Last modified:       30.6.2025
--
-- Filename:            env.adb
--
-- Description:         Provides the drivers required for simulating the
--                      environment in which the SPS operates.

pragma SPARK_Mode (Off);
with Text_IO, LGU, BSU, PCU; 
use type LGU.Speed_Type;

package body Env is

   Env_File: Text_IO.File_Type;

   package Integer_INOUT is new Text_IO.Integer_IO(Integer);

   procedure Update is
      
      SSensor_1: Integer;
      SSensor_2: Integer;
      SSensor_3: Integer;
      
      PSensor_1: Integer;
      PSensor_2: Integer;
      
      SafeBrakingModeSignal: Integer;
      
      TR_Signal: Integer;
      GS_Signal: Integer;


   begin
      -- Update env file
      -- Update LGU speed sensor readings
      Integer_INOUT.Get(Env_File, SSensor_1);
      Integer_INOUT.Get(Env_File, SSensor_2);
      Integer_INOUT.Get(Env_File, SSensor_3);
      LGU.Write_SpeedSensors(SSensor_1, SSensor_2, SSensor_3);
      
      LGU.Update_SpeedSensorErrorCount(1);
      LGU.Update_SpeedSensorErrorCount(2);
      LGU.Update_SpeedSensorErrorCount(3);
      
      -- Update LGU load sensor readings
      Integer_INOUT.Get(Env_File, PSensor_1);
      Integer_INOUT.Get(Env_File, PSensor_2);
      LGU.Write_LoadSensors(PSensor_1, PSensor_2);

      -- Update Safe Braking Mode
      Integer_INOUT.Get(Env_File, SafeBrakingModeSignal);
      if (SafeBrakingModeSignal = 1) then 
         PCU.EnableSafeBrakingMode;
      else 
         PCU.DisableSafeBrakingMode;
      end if;
      
      -- Update Thrust Reverser (TR): control action by pilot
      Integer_INOUT.Get(Env_File, TR_Signal);
      if (TR_Signal = 1) then 
         PCU.RequestDeployThrustReversers;
      else 
         PCU.RequestStowThrustReversers;
      end if;   
      
      -- Update Ground Spoiler (GS): control action by pilot
      Integer_INOUT.Get(Env_File, GS_Signal);
      if (GS_Signal = 1) then 
         PCU.RequestExtendGroundSpoilers;
      else 
         PCU.RequestRetractGroundSpoilers;
      end if;      

      
      Text_IO.Put('.');
      
   end Update;

   function At_End return Boolean is
   begin
      return Text_IO.End_Of_File(Env_File);
   end At_End;

   procedure Open_File is
   begin
      Text_IO.Open(Env_File, Text_IO.In_File, "env.dat");
   end Open_File;

   procedure Close_File is
   begin
      Text_IO.Close(Env_File);
      Text_IO.Put_Line(" [ complete ]");
   end Close_File;

end Env;


