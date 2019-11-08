%Name:          RotateSwarm
%Description:   Generates rotated X,Y positions for each swarm
%--------------------------------------------------------------------------
%INPUT:         -TO DO-
%--------------------------------------------------------------------------               
%OUTPUT:        -TO DO-
%--------------------------------------------------------------------------
function [crossXY_rotate,pentXY_rotate] = RotateSwarm(crossXY,pentXY,...
                                                        crossZ,pentZ,...
                                                        SWARM_RADIUS,...
                                                        Formation,Center,...
                                                        NUM_CROSS,NUM_PENT)
                                                    
if(Formation == "Cross" && Center == "Yes")
    crossXY_rotate = zeros(NUM_CROSS,360,3); % holds antennas' rotating xy positions
    for m = 2:NUM_CROSS
        crossXY_rotate(m,1,1) = crossXY(m,1);
        crossXY_rotate(m,1,2) = crossXY(m,2);
        theta0 = atan(crossXY(m,2)/crossXY(m,1));
        for i = 2:360
            theta0 = theta0 + (pi/180);
            crossXY_rotate(m,i,1) = SWARM_RADIUS * cos(theta0);
            crossXY_rotate(m,i,2) = SWARM_RADIUS * sin(theta0);
                if m == 4||m==3      % done to fix sign errors
                    crossXY_rotate(m,i,1)= -crossXY_rotate(m,i,1);
                    crossXY_rotate(m,i,2)= -crossXY_rotate(m,i,2);
                end
        end
    end

    for m = 1:NUM_CROSS    % This loop assigns the z positions.
        for i = 1:360       % The drones hold their same z pos as they rotate.
             crossXY_rotate(m,i,3) = crossZ(m); 
        end
    end
    pentXY_rotate = 0;
end
%-----------------------------------------
if(Formation == "Cross" && Center == "No")
    crossXY_rotate = zeros(NUM_CROSS,360,3); % holds antennas' rotating xy positions
    for m = 1:NUM_CROSS
        theta0 = atan(crossXY(m,2)/crossXY(m,1));
        for i = 2:360
            theta0 = theta0 + (pi/180);
            crossXY_rotate(m,i,1) = SWARM_RADIUS * cos(theta0);
            crossXY_rotate(m,i,2) = SWARM_RADIUS * sin(theta0);
                if m == 3||m==2      % done to fix sign errors
                    crossXY_rotate(m,i,1)= -crossXY_rotate(m,i,1);
                    crossXY_rotate(m,i,2)= -crossXY_rotate(m,i,2);
                end
        end
    end

    for m = 1:NUM_CROSS    % This loop assigns the z positions.
        for i = 1:360       % The drones hold their same z pos as they rotate.
             crossXY_rotate(m,i,3) = crossZ(m); 
        end
    end
    pentXY_rotate = 0;
end
%-------------------------------------------
if(Formation == "Pentagon" && Center == "Yes")
    pentXY_rotate = zeros(NUM_PENT,360,3); % holds antennas' rotating xy positions
    for m = 2:NUM_PENT
        pentXY_rotate(m,1,1) = pentXY(m,1);
        pentXY_rotate(m,1,2) = pentXY(m,2);
        theta0 = atan(pentXY(m,2)/pentXY(m,1));
        for i = 2:360
            theta0 = theta0 + (pi/180);
            pentXY_rotate(m,i,1) = SWARM_RADIUS * cos(theta0);
            pentXY_rotate(m,i,2) = SWARM_RADIUS * sin(theta0);
                if m == 4||m==3      % done to fix sign errors
                    pentXY_rotate(m,i,1)= -pentXY_rotate(m,i,1);
                    pentXY_rotate(m,i,2)= -pentXY_rotate(m,i,2);
                end
        end
    end

    for m = 1:NUM_PENT    % This loop assigns the z positions.
        for i = 1:360       % The drones hold their same z pos as they rotate.
             pentXY_rotate(m,i,3) = pentZ(m); 
        end
    end
    crossXY_rotate = 0;
end
%-------------------------------------------
if(Formation == "Pentagon" && Center == "No")
    pentXY_rotate = zeros(NUM_PENT,360,3); % holds antennas' rotating xy positions
    for m = 1:NUM_PENT
        theta0 = atan(pentXY(m,2)/pentXY(m,1));
        for i = 2:360
            theta0 = theta0 + (pi/180);
            pentXY_rotate(m,i,1) = SWARM_RADIUS * cos(theta0);
            pentXY_rotate(m,i,2) = SWARM_RADIUS * sin(theta0);
                if m == 4||m==3      % done to fix sign errors
                    pentXY_rotate(m,i,1)= -pentXY_rotate(m,i,1);
                    pentXY_rotate(m,i,2)= -pentXY_rotate(m,i,2);
                end
        end
    end

    for m = 1:NUM_PENT    % This loop assigns the z positions.
        for i = 1:360       % The drones hold their same z pos as they rotate.
             pentXY_rotate(m,i,3) = pentZ(m); 
        end
    end
    crossXY_rotate = 0;
end
if(Formation == "Both")
    % TO DO
    crossXY_rotate = 0;
    pentXY_rotate = 0;
end
end

