%Name:          SwarmWithCenter
%Description:   This function will generate a Swarm with X outer antennas
%               and a center antenna. 
%--------------------------------------------------------------------------
%INPUT:         # of antennas to surround center antenna.
%--------------------------------------------------------------------------               
%OUTPUT:        Swarm Coordinates for desired formation.
%--------------------------------------------------------------------------               
function [swarm] = SwarmWithCenter(NUM_DRONES,SWARM_RADIUS)
    swarm = zeros(NUM_DRONES, 2);
    inc = 2 * pi / (NUM_DRONES-1);
    for i = 2:NUM_DRONES
        angle = (i-1) * inc;
        [swarm(i,1), swarm(i,2)] = pol2cart(angle, SWARM_RADIUS);
    end
end

