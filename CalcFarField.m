%Name:          CalcFarField Function
%Description:   This function will calculate the FarField Pattern of a
%               given swarm.
%--------------------------------------------------------------------------
%INPUT:         swarm_xy (All drone x and y positions in the swarm)
%               swarm_z (All drone z positions in the swarm)
%               FREQUENCY (Operating frequency in [hz])
%               NUM_DRONES
%--------------------------------------------------------------------------               
%OUTPUT:        Eq (The Farfield Pattern of the swarm)
%--------------------------------------------------------------------------
function [Eq] = CalcFarField(swarm_xy, swarm_z, FREQUENCY, NUM_DRONES)
Eq = 0;c = 2.9992458*(10.^8);u0 = 4*pi*(10.^-7);
e0 = 1/((c.^2)*(u0));w = 2 * pi * FREQUENCY;
k0 = w*sqrt(u0*e0);center_of_swarm = [25,0,100];
xs = center_of_swarm(1);ys = center_of_swarm(2);
zs = center_of_swarm(3);rs = norm(center_of_swarm);
theta_s = acos(zs/rs);phi_s = atan2(ys,xs);
phi = 0:0.01:2*pi;Kn = 0;
for i = 1:NUM_DRONES
    xp = swarm_xy(i,1);
    yp = swarm_xy(i,2);
    zp = swarm_z(i);
    alt1 = -k0 * xp * sin(theta_s) * cos(phi_s);
    alt2 = alt1 - k0 * yp * sin(theta_s) * sin(phi_s);
    alt3 = alt2 - k0 * zp * cos(theta_s);
    alt4 = exp(j * alt3);
    alt5 = alt4 * exp( j * k0 * (xp * cos(phi) + yp * sin(phi) ) );
    Eq = Eq + alt5;
end
end
