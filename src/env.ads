-- Filename:            env.ads
--
-- Description:         Provides the drivers required for simulating the
--                      environment in which the SPS operates.

pragma SPARK_Mode (Off); 
package Env is

  subtype Sensor_Range is Integer range 0..2;

  procedure Update;

  function At_End return Boolean;

  procedure Open_File;

  procedure Close_File;

end Env;



