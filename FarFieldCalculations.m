clc
clear

% This program calculate the far-field pattern of a swarm of drones
% carrying scatters. 

% FREQUENCY = input('Input the operating frequency: ');
% BEAM_DIRECTION = input('Specify the desired direction of the main beam: ');
% BEAM_DIRECTION_2 = input('Specify the desired direction of the redirected beam: ');
% NUM_DRONES = input('Input the number of drones within swarm: ');
% SWARM_RADIUS = input('Input the swarm radius: ');
% MAX_ERROR_ALLOWED input('Input the max allowed position error: ');
% Kn = input('Specify kn''s coefficient: ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% BEGIN FORM REQUEST AND RETURN VALUES  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ ExcelRead, Defaults, Formation, Center, Offset, Rotate] = GenerateForm();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  VARIABLES  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Users may change these variables for quick modifications to the
%   simulation.
BEAM_DIRECTION = 45;        % Initial direction of beam in degrees
BEAM_DIRECTION_2 = 270;     % Second beam direction in degrees
FREQUENCY = 1.2 * 10^(9);   % Frequency in Hz
MAX_ERROR_ALLOWED = .01;    % Used to show effects of misplacements in xy
SWARM_RADIUS = (6.25/100);       % Position of drones in cross pattern
NUM_DRONES = 5;
Kn=0;  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Generate Cross XY positions  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generates a pattern with a single drone in the middle and
%   NUM_DRONES-1 antennas evenly spaced around it.
crossXY = zeros(NUM_DRONES, 2);
inc = 2 * pi / (NUM_DRONES-1);
for i = 2:NUM_DRONES
    angle = (i-1) * inc;
    [crossXY(i,1), crossXY(i,2)] = pol2cart(angle, SWARM_RADIUS);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  Generate Pentagon XY positions  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pentXY = zeros(5,2);
inc = (2 * pi / NUM_DRONES);
for i = 1:NUM_DRONES 
    angle = i * inc;
    [pentXY((i),1), pentXY((i),2)] = pol2cart(angle, SWARM_RADIUS);
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
swarm_z = CalcZPos(crossXY, BEAM_DIRECTION, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Calculation of 1st far field graph  %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Far Field pattern for original beam direction.
InitialField = CalcFarField(crossXY, swarm_z, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Recalculation using new theta  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Calculations of z pos for 2nd graph  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate new z positions for the redirected beam.
swarm_z_2 = CalcZPos(crossXY, BEAM_DIRECTION_2, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  Calculation of redirected far field graph  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Next we need to generate the far field pattern of the 
%   redirected beam.
RedirectedField = CalcFarField(crossXY, swarm_z_2, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Generate Z pos for Pentagon %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generates z positions for each of the antennas by implementing
%   eq 30. This equation assumes we are in the far field.
pent_swarm_z = CalcZPos(pentXY, BEAM_DIRECTION, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  Far Field Calculation for Pentagon  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Far Field pattern for original beam direction.
pentPattern = CalcFarField(pentXY, pent_swarm_z, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  Calculation of Jitter far field graph  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section is to show the effects of misplaced antennas in the 
%   x, y, and z positions. It will be a randomly generated offset
%   between -1 and 1 which will be multiplied by MAX_ERROR_ALLOWED.
[offset_pos, offset_field] = OffsetFarField(crossXY, swarm_z, MAX_ERROR_ALLOWED, FREQUENCY, NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  GRAPHING SECTION  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  Creating 1st Graph  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This graph demontstrates that by varying the z position, we 
%   can redirect the focused beam.
norm = max(InitialField);     % Get max val to normalize
figure(1);
polarplot(phi, abs(InitialField)/abs(norm));
title('Variation of Beam Direction')
rlim([0 1]);
hold on
norm2 = max(RedirectedField);
polarplot(phi, abs(RedirectedField)/abs(norm2), '--' );
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  Creating Offset Graph  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This graph depicts the correct xy positions vs the incorrectly
%   placed antennas in xy plane and the resulting far field 
%   patterns.
figure(2);
% tiledlayout(2,2)
% nexttile;
scatter(crossXY(:,1), crossXY(:,2),'filled');
title('Correct vs Misplaced: Top-Down View')
hold on
scatter(offset_pos(:,1), offset_pos(:,2));
xlabel('X Axis')
ylabel('Y Axis')
hold off

% nexttile
figure(3);
scatter(crossXY(:,1), swarm_z(:),'filled');
title('Correct vs Misplaced: Side View')
xlabel('X Axis')
ylabel('Z Axis')
hold on
scatter(offset_pos(:,1), offset_pos(:,3));
hold off

% nexttile
figure(4);
plot3(offset_pos(:,1), offset_pos(:,2), offset_pos(:,3), 'o');
title('3D Position Plot')
grid on
hold on
plot3(crossXY(:,1), crossXY(:,2),swarm_z(:), '*');
hold off

% nexttile
figure(5);
polarplot(phi, abs(InitialField)/abs(norm));
rlim([0 1]);
title('Effect on Far Field Pattern')
hold on
polarplot(phi, abs(offset_field)/abs(norm), '--' );
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  Creating Pent Graphs  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This graph shows the far field pattern created by having the
%   antenna in a pentagon formation.
figure(6);
% tiledlayout(1,2);
% nexttile;
scatter(pentXY(:,1),pentXY(:,2), 'filled'); 
title('Pentagon Positions')
norm3 = max(pentPattern);     % Get max val to normalize
hold off
% nexttile;
figure(7);
polarplot(phi, abs(pentPattern)/abs(norm3));
title('Pentagon Far Field')
rlim([0 1]);
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Generate rotating swarm positions  %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

figure(8);
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
figure(9);
polarplot(phi, abs(rotMagnitudes)/abs(normRotate));
title('Rotating swarm FarField')