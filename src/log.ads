--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Provides logger that records state information on the
--                      component parts of the SPU at run-time.

-- with Spark_IO;
pragma SPARK_Mode (Off);
package Log is
   
  procedure Update;

  procedure Open_File;

  procedure Close_File;

end Log;



