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
clc
clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% BEGIN FORM REQUEST AND RETURN VALUES  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set true to generate form, else set to false.
FormRead = "false";

%Check GenerateForm.m for a list of defaults when form is not generated.
[ExcelRead, Defaults, Formation, Center, Offset, Rotate] = GenerateForm(FormRead);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Load in Excel Sheet Data  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(ExcelRead == "Yes")
    %TO DO: Implement Excel Read.
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
    BEAM_DIRECTION = input("Input the desired beam direction");
    BEAM_DIRECTION_2 = input("Input a redirected beam direction");
    FREQUENCY = input("Input the operating frequency");
    MAX_ERROR_ALLOWED = input("Input the maximum allowed error in [m]");
    SWARM_RADIUS = input("Input the radius of the swarm in [m]");
    NUM_OUTER_DRONES = input("Specify the # of outer drones in swarm");
    NUM_DRONES = NUM_OUTER_DRONES + 1;
    Kn = input("Specify a Kn Value");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Generate Drone Formations  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[crossXY,pentXY] = GenerateSwarms(Formation,Center,SWARM_RADIUS);

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

[crossZ,pentZ] = GenerateZ(Formation,Center,...
                            crossXY,pentXY,...
                            BEAM_DIRECTION,...
                            FREQUENCY,NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  Calculation of far field graphs  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[crossField,pentField] = GenerateFarFields(Formation,Center,...
                                            crossXY,pentXY,...
                                            crossZ,pentZ,...
                                            FREQUENCY,NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Recalculation using new theta  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate new z positions for the redirected beam.
[crossZ2,pentZ2] = GenerateZ(Formation,Center,...
                                crossXY,pentXY,...
                                BEAM_DIRECTION_2,...
                                FREQUENCY,NUM_DRONES);

% Calculation of redirected far field graph
[crossField2,pentField2] = GenerateFarFields(Formation,Center,...
                                            crossXY,pentXY,...
                                            crossZ2,pentZ2,...
                                            FREQUENCY,NUM_DRONES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  Calculation of Jitter far field graphs  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cross_offset_pos, cross_offset_field,...
    pent_offset_pos,pent_offset_field] = ...
                                    GenerateOffsets(Offset,Center,...
                                                    crossXY, pentXY,...
                                                    crossZ,pentZ,...
                                                    MAX_ERROR_ALLOWED,...
                                                    FREQUENCY,NUM_DRONES);
                                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  Calculation of Rotating Swarm Field  %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  GRAPHING SECTION  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  Plot Initial FarField  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Formation == "Cross")
norm = max(crossField);     % Get max val to normalize
figure(1);
tiledlayout(1,1)
nexttile;
polarplot(phi, abs(crossField)/abs(norm));  
title('Cross Far Field Plot')
rlim([0 1]);
end

if(Formation == "Pentagon")
norm = max(pentField);     % Get max val to normalize
figure(1);
tiledlayout(1,1)
nexttile;
polarplot(phi, abs(pentField)/abs(norm));  
title('Pentagon Far Field Plot')
rlim([0 1]);
end

if(Formation == "Both")
norm = max(crossField);     % Get max val to normalize
figure(1);
tiledlayout(1,2)

nexttile;
polarplot(phi, abs(crossField)/abs(norm));  
title('Cross Far Field Plot')
rlim([0 1]);

nexttile;
polarplot(phi, abs(pentField)/abs(norm));  
title('Pentagon Far Field Plot')
rlim([0 1]);
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

if(Offset == "Cross") 
    figure(2);
    tiledlayout(2,2)
    
    nexttile; %Top-Down View
    scatter(crossXY(:,1), crossXY(:,2),'filled');
    title('Correct vs Misplaced: Top-Down View')
    xlabel('X Axis')
    ylabel('Y Axis')
    hold on
    scatter(cross_offset_pos(:,1), cross_offset_pos(:,2));
    hold off
    
    nexttile; % Side View
    scatter(crossXY(:,1), crossZ(:),'filled');
    title('Correct vs Misplaced: Side View')
    xlabel('X Axis')
    ylabel('Z Axis')
    hold on
    scatter(cross_offset_pos(:,1), cross_offset_pos(:,3));
    hold off
    
    nexttile; % 3D View
    plot3(cross_offset_pos(:,1), cross_offset_pos(:,2), cross_offset_pos(:,3), 'o');
    title('3D Position Plot')
    grid on
    hold on
    plot3(crossXY(:,1), crossXY(:,2),crossZ(:), '*');
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
%     scatter(pentXY(:,1), pentZ(:),'filled');
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
%     plot3(pentXY(:,1), pentXY(:,2),pentZ(:), '*');
%     hold off
% end

if(Offset == "Both")
    % TO DO
end

if(Offset == "Cross") %TEMPORARY IF, until implementation complete
nexttile;
polarplot(phi, abs(crossField)/abs(norm));
rlim([0 1]);
title('Effect on Far Field Pattern')
hold on
polarplot(phi, abs(cross_offset_field)/abs(norm), '--' );
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
             xyRotate(m,i,3) = crossZ(m); 
        end
    end

    % figure(3);
    % choice = 2; %from 1-5
    % scatter(xyRotate(choice,:,1),xyRotate(choice,:,2),[],(1:size(xyRotate,2)).','.');
    % colormap(jet) %From blue to red for Drone 2
    % title('Rotating swarm xy')
    % hold off

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
    figure(3);
    polarplot(phi, abs(rotMagnitudes)/abs(normRotate));
    title('Rotating swarm FarField')
    hold off;

end