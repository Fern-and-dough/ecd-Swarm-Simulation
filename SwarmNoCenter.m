%Name:          SwarmNoCenter
%Description:   This function will generate a Swarm with X outer antennas
%               and without a center antenna.
%--------------------------------------------------------------------------
%INPUT:         # of antennas.
%--------------------------------------------------------------------------               
%OUTPUT:        Swarm Coordinates for desired formation.
%--------------------------------------------------------------------------               
function [swarm] = SwarmNoCenter(NUM_DRONES,SWARM_RADIUS)
swarm = zeros(NUM_DRONES-1, 2);
    inc = 2 * pi / (NUM_DRONES-1);
    for i = 1:NUM_DRONES
        angle = i * inc;
        [swarm(i,1), swarm(i,2)] = pol2cart(angle, SWARM_RADIUS);
    end
end

