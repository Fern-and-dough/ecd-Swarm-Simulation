%Name:          RotateSwarm
%Description:   Generates rotated fields for each swarm
%--------------------------------------------------------------------------
%INPUT:         -TO DO-
%--------------------------------------------------------------------------               
%OUTPUT:        -TO DO-
%--------------------------------------------------------------------------
function [cross_rot_field,pent_rot_field] = RotateField(crossXY_rotate,...
                                                        pentXY_rotate,...
                                                        Formation,...
                                                        BEAM_DIRECTION,...,
                                                        FREQUENCY,...
                                                        NUM_CROSS,NUM_PENT)
                                                    
                                                    
c = 2.9992458*(10.^8); u0 = 4*pi*(10.^-7); e0 = 1/((c.^2)*(u0));
w = 2 * pi * FREQUENCY; k0 = w*sqrt(u0*e0); center_of_swarm = [25,0,100];
xs = center_of_swarm(1); ys = center_of_swarm(2); zs = center_of_swarm(3);
rs = norm(center_of_swarm); theta_s = acos(zs/rs);
phi_s = atan2(ys,xs);

if(Formation == "Cross")                                                    
    for m = 1:360
        Mag=0;
        for i = 1:NUM_CROSS
            xp = crossXY_rotate(i,m,1);
            yp = crossXY_rotate(i,m,2);
            zp = crossXY_rotate(i,m,3);
            alt1 = -k0 * xp * sin(theta_s) * cos(phi_s);
            alt2 = alt1 - k0 * yp * sin(theta_s) * sin(phi_s);
            alt3 = alt2 - k0 * zp * cos(theta_s);
            alt4 = exp(j * alt3);
            alt5 = alt4 * exp( j * k0 * (xp * cos(BEAM_DIRECTION) + yp * sin(BEAM_DIRECTION) ) );
            Mag = Mag + alt5;
        end
        cross_rot_field(m) = Mag;
    end
    pent_rot_field = 0;
end
if(Formation == "Pentagon")                                                    
    for m = 1:360
        Mag=0;
        for i = 1:NUM_PENT
            xp = pentXY_rotate(i,m,1);
            yp = pentXY_rotate(i,m,2);
            zp = pentXY_rotate(i,m,3);
            alt1 = -k0 * xp * sin(theta_s) * cos(phi_s);
            alt2 = alt1 - k0 * yp * sin(theta_s) * sin(phi_s);
            alt3 = alt2 - k0 * zp * cos(theta_s);
            alt4 = exp(j * alt3);
            alt5 = alt4 * exp( j * k0 * (xp * cos(BEAM_DIRECTION) + yp * sin(BEAM_DIRECTION) ) );
            Mag = Mag + alt5;
        end
        pent_rot_field(m) = Mag;
    end
    cross_rot_field = 0;

end
%TODO: Implement Both or "All"
end

