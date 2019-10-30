clc
clear
%Name:          FarFieldCalculations
%Description:   This program calculate the far-field pattern of a swarm of drones
%               carrying scatters. 
%--------------------------------------------------------------------------
%INPUT:         Excel Values, User-Specified, or Default values to obtain:
%
%               FREQUENCY (Operating frequency in [Hz])
%               BEAM_DIRECTION (Initial direction of beam in [degrees])
%               BEAM_DIRECTION_2 (Second beam direction in [degrees])
%               NUM_DRONES = input('Input the number of drones within swarm: ')
%               SWARM_RADIUS = input('Input the swarm radius: ')
%               MAX_ERROR_ALLOWED input('Input the max allowed position error: ')
%               Kn = input('Specify kn''s coefficient: ')
%--------------------------------------------------------------------------               
%OUTPUT:        Far field Patterns and interesting related plots
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% BEGIN FORM REQUEST AND RETURN VALUES  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set true to generate form, else set to false
FormRead = "false";

[ExcelRead, Defaults, Formation, Center, Offset, Rotate] = GenerateForm(FormRead);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Load in Excel Sheet Data  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(ExcelRead == "Yes")
    %TO DO: Implement Excel Read
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  VARIABLES  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Defaults == "Yes")
% Users may also change these variables for quick modifications to the
% simulation.
BEAM_DIRECTION = 45;        
BEAM_DIRECTION_2 = 270;     % Second beam direction in degrees
FREQUENCY = 1.2 * 10^(9);   % Frequency in Hz
MAX_ERROR_ALLOWED = .01;    % Used to show effects of misplacements in xy
SWARM_RADIUS = (6.25/100);       % Position of drones in cross pattern
NUM_OUTER_DRONES = 4; %4 - Cross, 5 - Pentagon
NUM_DRONES = NUM_OUTER_DRONES + 1;
Kn=0;  
else
    %TO DO, set user inputs
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Generate Drone Formations  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TO DO: Implement Form option *Formation* to create both Patterns
% Create seperate functions to minimize code block here

if(Formation == "Cross" && Center == "Yes")
    % Generate Cross Swarm Pattern
    % WITH Center Antenna in the Middle
    % With NUM_Drones - 1 antennas evenly spaced around the center
    crossXY = zeros(NUM_DRONES, 2);
    inc = 2 * pi / (NUM_DRONES-1);
    for i = 2:NUM_DRONES
        angle = (i-1) * inc;
        [crossXY(i,1), crossXY(i,2)] = pol2cart(angle, SWARM_RADIUS);
    end
end

if(Formation == "Pentagon" && Center == "Yes")
    % Generate Pentagon Swarm Pattern
    % WITH Center Antenna in the Middle
    % With NUM_Drones - 1 antennas evenly spaced around the center
    pentXY = zeros(NUM_DRONES,2);
    inc = 2 * pi / (NUM_DRONES - 1);
    for i = 2:NUM_DRONES 
        angle = (i-1) * inc;
        [pentXY(i,1), pentXY(i,2)] = pol2cart(angle, SWARM_RADIUS);
    end
end

if(Formation == "Cross" && Center == "No")
    % Generate Cross Swarm Pattern
    % WITHOUT Center Antenna in the Middle
    % With NUM_Drones - 1 antennas evenly spaced around the center
    crossXY = zeros(NUM_DRONES-1, 2);
    inc = 2 * pi / (NUM_DRONES-1);
    for i = 1:NUM_DRONES
        angle = i * inc;
        [crossXY(i,1), crossXY(i,2)] = pol2cart(angle, SWARM_RADIUS);
    end
end

if(Formation == "Pentagon" && Center == "No")
    % Generate Pentagon Swarm Pattern
    % WITHOUT Center Antenna in the Middle
    % With NUM_Drones antennas evenly spaced aroudn the center
    crossXY = zeros(NUM_DRONES-1, 2);
    inc = 2 * pi / (NUM_DRONES-1);
    for i = 1:NUM_DRONES
        angle = i * inc;
        [crossXY(i,1), crossXY(i,2)] = pol2cart(angle, SWARM_RADIUS);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Constants  %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 2.9992458*(10.^8); u0 = 4*pi*(10.^-7); e0 = 1/((c.^2)*(u0));
w = 2 * pi * FREQUENCY; k0 = w*sqrt(u0*e0); center_of_swarm = [25,0,100];
xs = center_of_swarm(1); ys = center_of_swarm(2); zs = center_of_swarm(3);
rs = norm(center_of_swarm); theta_s = acos(zs/rs);
phi_s = atan2(ys,xs); phi = 0:0.01:2*pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  Implementation of Equation (30)  %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generates z positions for each of the antennas by implementing
%   eq 30. This equation assumes we are in the far field.

%TO DO: Implement Form option *Formation* to create both Patterns

if(Formation == "Cross")
    swarm_z = CalcZPos(crossXY, BEAM_DIRECTION, FREQUENCY, NUM_DRONES);
end
if(Formation == "Pentagon")
    pent_swarm_z = CalcZPos(pentXY, BEAM_DIRECTION, FREQUENCY, NUM_DRONES);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Calculation of far field graphs  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Far Field pattern for original beam direction.

%TO DO: Implement Form option *Formation* to create both Patterns

if(Formation == "Cross")
    InitialField = CalcFarField(crossXY, swarm_z, FREQUENCY, NUM_DRONES);
end
if(Formation == "Pentagon")
    pentPattern = CalcFarField(pentXY, pent_swarm_z, FREQUENCY, NUM_DRONES);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Recalculation using new theta  %%%%%%%%%%%%%%%%%
%%%%%  WILL NEED AN OPTION IN THE FORM AND CODE BLOCK HERE %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate new z positions for the redirected beam.

% swarm_z_2 = CalcZPos(crossXY, BEAM_DIRECTION_2, FREQUENCY, NUM_DRONES);

% Calculation of redirected far field graph

% RedirectedField = CalcFarField(crossXY, swarm_z_2, FREQUENCY, NUM_DRONES);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  Calculation of Jitter far field graphs  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section is to show the effects of misplaced antennas in the 
%   x, y, and z positions. It will be a randomly generated offset
%   between -1 and 1 which will be multiplied by MAX_ERROR_ALLOWED.

if(Offset == "Cross")
    [offset_pos, offset_field] = OffsetFarField(crossXY, swarm_z, MAX_ERROR_ALLOWED, FREQUENCY, NUM_DRONES);
end

% Need to UPDATE OffsetFarField Function for Pentagon Offsets 

% if(Offset == "Pentagon") 
%     -----Insert Func Here-----
% end

if(Offset == "Both")
    [offset_pos, offset_field] = OffsetFarField(crossXY, swarm_z, MAX_ERROR_ALLOWED, FREQUENCY, NUM_DRONES);
%   -----Insert Func Here-----
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  GRAPHING SECTION  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TO DO: Implement Form option *Formation* to create both Patterns
% Create seperate functions to minimize code block here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Plot Initial FarField  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Formation == "Cross")
norm = max(InitialField);     % Get max val to normalize
figure(1);
polarplot(phi, abs(InitialField)/abs(norm));  
title('Cross Far Field Plot')
rlim([0 1]);
hold off
end

if(Formation == "Pentagon")
norm = max(pentPattern);     % Get max val to normalize
figure(1);
polarplot(phi, abs(pentPattern)/abs(norm));  
title('Cross Far Field Plot')
rlim([0 1]);
hold off
end

if(Formation == "Both")
% TO DO
end

% This graph will demonstrate that by varying the z position, we 
%   can redirect the focused beam.
%title('Variation of Beam Direction')
% hold on
% norm2 = max(RedirectedField);
% polarplot(phi, abs(RedirectedField)/abs(norm2), '--' );
%hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  Creating Offset Graph  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This graph depicts the correct xy positions vs the incorrectly
%   placed antennas in xy plane and the resulting far field 
%   patterns.

if(Offset == "Cross") %Top-Down View
    figure(2);
    scatter(crossXY(:,1), crossXY(:,2),'filled');
    title('Correct vs Misplaced: Top-Down View')
    hold on
    scatter(offset_pos(:,1), offset_pos(:,2));
    xlabel('X Axis')
    ylabel('Y Axis')
    hold off  
    
    figure(3); % Side View
    scatter(crossXY(:,1), swarm_z(:),'filled');
    title('Correct vs Misplaced: Side View')
    xlabel('X Axis')
    ylabel('Z Axis')
    hold on
    scatter(offset_pos(:,1), offset_pos(:,3));
    hold off
    
    figure(4); %3D View
    plot3(offset_pos(:,1), offset_pos(:,2), offset_pos(:,3), 'o');
    title('3D Position Plot')
    grid on
    hold on
    plot3(crossXY(:,1), crossXY(:,2),swarm_z(:), '*');
    hold off
end

% if(Offset == "Pentagon") %Top-Down View
%     figure(2);
%     scatter(pentXY(:,1), pentXY(:,2),'filled');
%     title('Correct vs Misplaced: Top-Down View')
%     hold on
%     scatter(offset_pos(:,1), offset_pos(:,2));
%     xlabel('X Axis')
%     ylabel('Y Axis')
%     hold off  
%     
%     figure(3); % Side View
%     scatter(pentXY(:,1), pent_swarm_z(:),'filled');
%     title('Correct vs Misplaced: Side View')
%     xlabel('X Axis')
%     ylabel('Z Axis')
%     hold on
%     scatter(offset_pos(:,1), offset_pos(:,3));
%     hold off
%     
%     figure(4); %3D View
%     plot3(offset_pos(:,1), offset_pos(:,2), offset_pos(:,3), 'o');
%     title('3D Position Plot')
%     grid on
%     hold on
%     plot3(pentXY(:,1), pentXY(:,2),pent_swarm_z(:), '*');
%     hold off
% end

if(Offset == "Both")
    % TO DO
end

if(Offset == "Cross") %TEMPORARY IF, until implementation complete
figure(5);
polarplot(phi, abs(InitialField)/abs(norm));
rlim([0 1]);
title('Effect on Far Field Pattern')
hold on
polarplot(phi, abs(offset_field)/abs(norm), '--' );
hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Generate rotating swarm positions  %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Offset == "Cross")
xyRotate = zeros(NUM_DRONES,360,3); % holds antennas' rotating xy positions
for m = 2:NUM_DRONES
    xyRotate(m,1,1) = crossXY(m,1);
    xyRotate(m,1,2) = crossXY(m,2);
    theta0 = atan(crossXY(m,2)/crossXY(m,1));
    for i = 2:360
        theta0 = theta0 + (pi/180);
        xyRotate(m,i,1) = SWARM_RADIUS * cos(theta0);
        xyRotate(m,i,2) = SWARM_RADIUS * sin(theta0);
            if m == 4||m==3      % done to fix sign errors
                xyRotate(m,i,1)= -xyRotate(m,i,1);
                xyRotate(m,i,2)= -xyRotate(m,i,2);
            end
    end
end
for m = 1:NUM_DRONES    % This loop assigns the z positions.
    for i = 1:360       % The drones hold their same z pos as they rotate.
         xyRotate(m,i,3) = swarm_z(m); 
    end
end

figure(6);
choice = 2; %from 1-5
scatter(xyRotate(choice,:,1),xyRotate(choice,:,2),[],(1:size(xyRotate,2)).','.');
colormap(jet) %From blue to red for Drone 2
title('Rotating swarm xy')
hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Generate rotating Far Field  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for m = 1:360
    Mag=0;
    for i = 1:5
        xp = xyRotate(i,m,1);
        yp = xyRotate(i,m,2);
        zp = xyRotate(i,m,3);
        alt1 = -k0 * xp * sin(theta_s) * cos(phi_s);
        alt2 = alt1 - k0 * yp * sin(theta_s) * sin(phi_s);
        alt3 = alt2 - k0 * zp * cos(theta_s);
        alt4 = exp(j * alt3);
        alt5 = alt4 * exp( j * k0 * (xp * cos(BEAM_DIRECTION) + yp * sin(BEAM_DIRECTION) ) );
        Mag = Mag + alt5;
    end
    rotMagnitudes(m) = Mag;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Graphing Rotating Far Field  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inc = pi/180;
phi = inc:inc:2*pi; % phi is 360 degrees at intervals of 1 degree
normRotate = max(rotMagnitudes);     % Get max val to normalize
figure(7);
polarplot(phi, abs(rotMagnitudes)/abs(normRotate));
title('Rotating swarm FarField')
hold off;

end