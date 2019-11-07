%Name:          CalcZPos
%Description:   This function will calculate the required z values needed
%               for each drone in the swarm to achieve overall beam
%               direction.
%--------------------------------------------------------------------------
%INPUT:         swarm_xy (All drone x and y positions in the swarm)
%               BEAM_DIRECTION (Desired beam direction)
%               FREQUENCY (Operating frequency in [hz])
%               NUM_DRONES
%--------------------------------------------------------------------------               
%OUTPUT:        swarm_z (All drone z positions in the swarm)
%--------------------------------------------------------------------------
function [swarm_z] = CalcZPos(swarm_xy, BEAM_DIRECTION, FREQUENCY,NUM_DRONES)
c = 2.9992458*(10.^8);
u0 = 4*pi*(10.^-7);
e0 = 1/((c.^2)*(u0));
w = 2 * pi * FREQUENCY;
k0 = w*sqrt(u0*e0);
center_of_swarm = [25,0,100];
xs = center_of_swarm(1);
ys = center_of_swarm(2);
zs = center_of_swarm(3);
rs = norm(center_of_swarm);
theta_s = acos(zs/rs);
phi_s = atan2(ys,xs);
Kn = 0;
swarm_z = zeros(NUM_DRONES,1);
for i = 1:NUM_DRONES
    xp = swarm_xy(i,1);
    yp = swarm_xy(i,2);
    alt1 = -k0 * xp * sin(theta_s) * cos(phi_s);
    alt2 = -k0 * yp * sin(theta_s) * sin(phi_s);
    alt3 = k0 * xp * cosd(BEAM_DIRECTION);
    alt4 = k0 * yp * sind(BEAM_DIRECTION);
    const = 1/(cos(theta_s)*k0);
    swarm_z(i) = const * ( alt1 + alt2 + alt3 + alt4 + (Kn*(c/FREQUENCY)));
    end
end

