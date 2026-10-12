--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Directly controls the aircraft's thrust reversers
--                      and ground spoilers.

pragma SPARK_Mode (On);
package body BSU
is

   procedure DeployThrustReversers is
   begin
      ThrustReversersDeployed := True;
   end DeployThrustReversers;

   procedure StowThrustReversers is
   begin
      ThrustReversersDeployed := False;
   end StowThrustReversers;

   function isDeployedThrustReversers return Boolean is
   begin
      return ThrustReversersDeployed;
   end isDeployedThrustReversers;

   procedure ExtendGroundSpoilers is
   begin
      GroundSpoilersExtended := True;
   end ExtendGroundSpoilers;

   procedure RetractGroundSpoilers is
   begin
      GroundSpoilersExtended := False;
   end RetractGroundSpoilers;

   function isExtendedGroundSpoilers return Boolean is
   begin
      return GroundSpoilersExtended;
   end isExtendedGroundSpoilers;

begin
   ThrustReversersDeployed := False;
   GroundSpoilersExtended  := False;
end BSU;
