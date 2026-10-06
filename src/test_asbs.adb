--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Test harness for the ASBS. Note that test data and results
--                      are managed via the Env and Log packages respectively.

pragma SPARK_Mode (Off);
with Env, Log, BSCU, LGU, BSU, PCU;
use type LGU.Speed_Type;
procedure Test_ASBS is
begin
   Env.Open_File;
   Log.Open_File;
   loop
      exit when Env.At_End;
      Env.Update;
      Log.Update;
      BSCU.Controller;
      Log.Update;
   end loop;
   Env.Close_File;
   Log.Close_File;
end Test_ASBS;

