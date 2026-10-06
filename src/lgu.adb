--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Monitors the aircraft's landing gear load sensors and wheel speed sensors.
--                      Note that a single wheel speed sensor reading is calculated
--                      using a majority vote algorithm.

pragma SPARK_Mode (On);
package body LGU
is

   procedure Write_SpeedSensors(Value_1, Value_2, Value_3: in Speed_Type) is
   begin
      SpeedSensorsState(1).Value := Value_1;
      SpeedSensorsState(2).Value := Value_2;
      SpeedSensorsState(3).Value := Value_3;
   end Write_SpeedSensors;

   procedure Update_SpeedSensorErrorCount(Speed_Sensors_Index: in Speed_Sensors_Index_Type) is
   begin
      if SpeedSensorsState(Speed_Sensors_Index).Value = Err_Value then
         SpeedSensorsState(Speed_Sensors_Index).ErrCnt :=
           SpeedSensorsState(Speed_Sensors_Index).ErrCnt + 1;
      end if;
   end Update_SpeedSensorErrorCount;

   function Read_SpeedSensor(Speed_Sensors_Index: in Speed_Sensors_Index_Type) return Speed_Type is
   begin
      return SpeedSensorsState(Speed_Sensors_Index).Value;
   end Read_SpeedSensor;

   function Read_SpeedSensorErrorCount(Speed_Sensors_Index: in Speed_Sensors_Index_Type) return Integer is
   begin
      return SpeedSensorsState(Speed_Sensors_Index).ErrCnt;
   end Read_SpeedSensorErrorCount;

   function Read_SpeedSensor_Majority return Speed_Type is
      V1: constant Speed_Type := SpeedSensorsState(1).Value;
      V2: constant Speed_Type := SpeedSensorsState(2).Value;
      V3: constant Speed_Type := SpeedSensorsState(3).Value;
   begin
      if V1 = V2 or else V1 = V3 then
         return V1;
      elsif V2 = V3 then
         return V2;
      else
         return Err_Value;
      end if;
   end Read_SpeedSensor_Majority;

   procedure Write_LoadSensors(Value_1, Value_2: in Load_Sensor_Type) is
   begin
      LoadSensorsState(1) := Value_1;
      LoadSensorsState(2) := Value_2;
   end Write_LoadSensors;

   function Read_LoadSensor(Load_Sensors_Index: in Load_Sensors_Index_Type) return Load_Sensor_Type is
   begin
      return LoadSensorsState(Load_Sensors_Index);
   end Read_LoadSensor;

begin
   SpeedSensorsState := (others => (Value => 0, ErrCnt => 0));
   LoadSensorsState  := (others => 0);
end LGU;