
--
-- Description:         Provides logger that records state information on the
--                      component parts of the SPU at run-time.

pragma SPARK_Mode (Off);
with Text_IO, LGU, BSU, PCU, BSCU;
use type LGU.Speed_Type;
use type PCU.Position;
-- use type BSU.Position;
package body Log is

   package Sensor_INOUT is new Text_IO.Enumeration_IO(LGU.Speed_Type);
   -- use Sensor_INOUT;
   package Integer_INOUT is new Text_IO.Integer_IO(Integer);
   -- use Integer_INOUT;

   Log_File: Text_IO.File_Type;
   
   procedure Update is

   begin
      -- Update log file
	   Text_IO.Put(Log_File, "| ");
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensor(1), 5);
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensor(2), 7);
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensor(3), 7);
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensor_Majority, 7);
	   Text_IO.Put(Log_File, " ");
    
      Text_IO.Put(Log_File, "| ");
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensorErrorCount(1), 5);
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensorErrorCount(2), 7);
      Integer_INOUT.Put(Log_File, LGU.Read_SpeedSensorErrorCount(3), 7);
      Text_IO.Put(Log_File, " |");
      Integer_INOUT.Put(Log_File, LGU.Read_LoadSensor(1), 4);
      Integer_INOUT.Put(Log_File, LGU.Read_LoadSensor(2), 5);
      Text_IO.Put(Log_File, " | ");
      if PCU.SafeBrakingModeEnabled then
	      Text_IO.Put(Log_File, "  D ");
      else
	      Text_IO.Put(Log_File, "U   ");
      end if;
      Text_IO.Put(Log_File, " ");
      if not(PCU.isRequestedDeployThrustReversers) then
	      Text_IO.Put(Log_File, "F   ");
      else
	      Text_IO.Put(Log_File, "  R ");
      end if;
      Text_IO.Put(Log_File, " ");
      if not(PCU.isRequestedExtendGroundSpoilers) then
	      Text_IO.Put(Log_File, "F   ");
      else
	      Text_IO.Put(Log_File, "  R ");
      end if;
      Text_IO.Put(Log_File, " ");
      if PCU.isEnabledSensorAlarm then
	     Text_IO.Put(Log_File,  "ON");
      else
	      Text_IO.Put(Log_File, "--");
      end if;      
      Text_IO.Put(Log_File, "  | ");
      if (BSU.ThrustReversersDeployed) then
	      Text_IO.Put(Log_File, "DEP  ");
      else
	      Text_IO.Put(Log_File, "---  ");
      end if;
      if (BSU.GroundSpoilersExtended) then
	      Text_IO.Put(Log_File, "EXT ");
      else
	      Text_IO.Put(Log_File, "--- ");
      end if;
      Text_IO.Put(Log_File, "| ");
      Text_IO.New_Line(Log_File);            
   end Update;   
   
   procedure Open_File is
   begin
      Text_IO.Create(Log_File, Text_IO.Out_File, "log.dat");
	  Text_IO.Put_Line(Log_File," ");
Text_IO.Put_Line(Log_File,
                                                                
               "|---------------------------------------------------------------------------------------------|");
	  Text_IO.Put_Line(Log_File,                                             
               "|                           Aircraft Safe Braking System (ASBS) LOG                           |");
	  Text_IO.Put_Line(Log_File,   
               "|---------------------------------------------------------------------------------------------|");		   
	  Text_IO.Put_Line(Log_File,
               "|                                LGU                          |         PCU        |   BSU    |");
	  Text_IO.Put_Line(Log_File,    
               "|-------------------------------------------------------------|                    |          |");   
      Text_IO.Put_Line(Log_File,                                                                      
               "|                      SPEED SENSORS               |  LOAD    |                    |          |");
      Text_IO.Put_Line(Log_File,                                                                     
               "|            READINGS        |    ERROR COUNTS     | SENSORS  |                    |          |");
      Text_IO.Put_Line(Log_File,                                               
               "|----------------------------|---------------------|-------------------------------|----------|");
	  Text_IO.Put_Line(Log_File,  
               "| SEN-1  SEN-2  SEN-3  MAJOR | ERR-1  ERR-2  ERR-3 | LGL  LGR | SBM  TRL  GSL  ALM | TR    GS |");
	  Text_IO.Put_Line(Log_File,
               "|----------------------------------------------------------------------------------|----------|");
	 -- Text_IO.New_Line(Log_File);            
   end Open_File;

   procedure Close_File is
   begin
      Text_IO.Put_Line(Log_File,
		        "|---------------------------------------------------------------------------------------------|");
      Text_IO.Put_Line(Log_File, "LGU = Landing Gear Unit; PCU = Plot Control Unit; BSU = Braking System Unit; ");
      Text_IO.Put_Line(Log_File, "MAJOR = majority reading of the wheel speed sensors, i.e., SEN-1, SEN-2, SEN-2;");
      Text_IO.Put_Line(Log_File, "ERR-1 = error count for SEN-1; ERR-2 = error count for SEN-2; ERR-3 = error count for SEN-3;");
      Text_IO.Put_Line(Log_File, "LGL = Landing Gear Left; LGR = Landing Gear Right;");
      Text_IO.Put_Line(Log_File, "SBM = Safe Braking Mode (Switch: U = Up, D = Down); ");
      Text_IO.Put_Line(Log_File, "TRL = Thrust Reversers (Lever: F = Forward, R = Reverse); ");
      Text_IO.Put_Line(Log_File, "GSL = Ground Spoilers (Lever: F = Forward, R = Reverse);  ");
      Text_IO.Put_Line(Log_File, "ALM = Alarm (for Speed and Load Sensors: if not ON then OFF); ");
      Text_IO.Put_Line(Log_File, "TR = Thrust Reversers (if not DEPloyed then STOWED); ");
      Text_IO.Put_Line(Log_File, "GS = Ground Spoilers (if not EXTended then RETRACTED). ");
      Text_IO.Close(Log_File);
   end Close_File;

end Log;

