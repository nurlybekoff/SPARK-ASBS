--
-- Author:              A. Ireland
-- Updateded:           20.5.2026
-- Description:         Directly controls the aircraft's thrust reversers 
--                      and ground spoilers. 


pragma SPARK_Mode (On);
package BSU

is
   pragma Elaborate_Body;
   
   ThrustReversersDeployed: Boolean; -- True when thrust reversers deployed, otherwise False.
   GroundSpoilersExtended:  Boolean; -- True when ground spoilers extended, otherwise False.
   
   -- Deploy the thrust reversers (braking system).
   procedure DeployThrustReversers
   with
     Global => (Output => ThrustReversersDeployed),
     Depends => (ThrustReversersDeployed => null);

   -- Stow the thrust reversers (braking system). 
   procedure StowThrustReversers
   with
     Global => (Output => ThrustReversersDeployed),
     Depends => (ThrustReversersDeployed => null);
   
   -- Returns True when thrust reversers are deployed; otherwise False.
   function isDeployedThrustReversers return Boolean
   with
     Global => (Input => ThrustReversersDeployed),
     Depends => (isDeployedThrustReversers'Result => ThrustReversersDeployed);

   -- Extend the ground spoilers (braking system).
   procedure ExtendGroundSpoilers
   with
     Global => (Output => GroundSpoilersExtended),
     Depends => (GroundSpoilersExtended => null);

   -- Retract the ground spoilers (braking system).
   procedure RetractGroundSpoilers
   with
     Global => (Output => GroundSpoilersExtended),
     Depends => (GroundSpoilersExtended => null);
   
   -- Returns True when ground spoilers are extended; otherwise False.
   function isExtendedGroundSpoilers return Boolean
   with 
     Global => (Input => GroundSpoilersExtended),
     Depends => (isExtendedGroundSpoilers'Result => GroundSpoilersExtended);

end BSU;



