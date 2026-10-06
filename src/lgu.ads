--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Monitors the aircraft's landing gear load sensors and wheel speed sensors.  
--                      Note that a single wheel speed sensor reading is calculated 
--                      using a majority vote algorithm.

pragma SPARK_Mode (On); 
package LGU
 
is
   
   pragma Elaborate_Body;
   
   -- Landing gear wheel speed readings.
   subtype Speed_Type is Integer range -1..200;
   
   -- Landing gear load sensor readings.
   subtype Load_Sensor_Type is Integer range -1..900;
   
   Err_Value: constant Speed_Type := -1; -- denotes an erroneous sensor reading.
 
   -- Each wheel speed sensor is modelled by a Value, i.e., the current speed reading, 
   -- and an error count (ErrCnt), i.e., the number of times an Err_Value reading has
   -- been given.
   type Speed_Sensor_Record is record
      Value:  Speed_Type;
      ErrCnt: Integer;
   end record;
   
   -- The 3 wheel sensors are modelled by an array of Speed_Sensor_Record records.
   subtype Speed_Sensors_Index_Type is Integer range 1..3;
   type    Speed_Sensors_Type is array (Speed_Sensors_Index_Type) of Speed_Sensor_Record;

   
   -- The 2 landing gear load sensors are represented as an array.
   subtype Load_Sensors_Index_Type is Integer range 1..2;
   type    Load_Sensors_Type is array (Load_Sensors_Index_Type) of Load_Sensor_Type;

   SpeedSensorsState:        Speed_Sensors_Type;    -- state of wheel speed sensors. 
   LoadSensorsState:     Load_Sensors_Type; -- state of load sensors.
 

   -- Wheel speed sensors:
   -- Updates the 3 Value fields of SpeedSensorsState with readings Value_1, Value_2, Value_3.
   procedure Write_SpeedSensors(Value_1, Value_2, Value_3: in Speed_Type)
   with 
     Global => (In_Out => SpeedSensorsState),
     Depends => (SpeedSensorsState => (SpeedSensorsState, Value_1, Value_2, Value_3));
   
   -- Updates the 3 ErrCnt fields of the SpeedSensorsState based on the current Value fields. 
   procedure Update_SpeedSensorErrorCount(Speed_Sensors_Index: in Speed_Sensors_Index_Type)
     with
       Global => (In_Out => SpeedSensorsState),
       Depends => (SpeedSensorsState => (SpeedSensorsState, Speed_Sensors_Index));       
   
   -- Given the SpeedSensorsState, returns the speed sensor Value indexed by Speed_Sensor_Index (1..3)
   function Read_SpeedSensor(Speed_Sensors_Index: in Speed_Sensors_Index_Type) return Speed_Type
   with
     Global  => (Input => SpeedSensorsState),
     Depends => (Read_SpeedSensor'Result => (SpeedSensorsState, Speed_Sensors_Index));
                
   -- Given the SpeedSensorsState, returns the speed sensor ErrCnt indexed by Speed_Sensor_Index (1..3)
   function Read_SpeedSensorErrorCount(Speed_Sensors_Index: in Speed_Sensors_Index_Type) return Integer
   with
     Global  => (Input => SpeedSensorsState),
     Depends => (Read_SpeedSensorErrorCount'Result => (SpeedSensorsState, Speed_Sensors_Index));

   -- Given the Speed SensorState, returns the majority sensor Value reading.  
   function Read_SpeedSensor_Majority return Speed_Type
   with
     Global  => (Input => SpeedSensorsState),
     Depends => (Read_SpeedSensor_Majority'Result => SpeedSensorsState);
   
   -- Load sensors:
   -- Updates the LoadSensorsState with the 2 load readings, i.e., Value_1 and Value_2.
   procedure Write_LoadSensors(Value_1, Value_2: in Load_Sensor_Type)
   with 
     Global  => (In_Out => LoadSensorsState),
     Depends => (LoadSensorsState => (LoadSensorsState, Value_1, Value_2));
   
   -- Given the LoadSensorsState, returns the load reading indexed by Load_Sensor_Index (1..2)
   function Read_LoadSensor(Load_Sensors_Index: in Load_Sensors_Index_Type) return Load_Sensor_Type
   with
     Global  => (Input => LoadSensorsState),
     Depends => (Read_LoadSensor'Result => (LoadSensorsState, Load_Sensors_Index));

end LGU;





















