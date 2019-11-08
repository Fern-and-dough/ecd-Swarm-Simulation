%Name:          GenerateSwarms
%Description:   This function will take in user input "Formation" and
%               "Center", producing crossXY and pentXY formations as
%               needed.
%--------------------------------------------------------------------------
%INPUT:         Formation ("*Cross*", "Pentagon", or "Both")
%               Center ("*Yes*" or "No")
%--------------------------------------------------------------------------               
%OUTPUT:        crossXY (Returns crossXY antenna positions, or 0)
%               pentXY (Returns pentXY antenna positions, or 0)
%
%NOTE: All Asterisk options are default form values
%--------------------------------------------------------------------------               
function [crossXY,pentXY] = GenerateSwarms(Formation, Center,SWARM_RADIUS)

%# of drones needed in each swarm
CROSS = 5;
PENT = 6;
%------------------------------------------------------
%Both Formations, Center Elements
if(Formation == "Both" && Center == "Yes")
    [crossXY] = SwarmWithCenter(CROSS,SWARM_RADIUS);
    [pentXY] = SwarmWithCenter(PENT,SWARM_RADIUS);
end

%Both Formations, No Center Elements
if(Formation == "Both" && Center == "No")
    [crossXY] = SwarmNoCenter(CROSS,SWARM_RADIUS);
    [pentXY] = SwarmNoCenter(PENT,SWARM_RADIUS);
end
%------------------------------------------------------
%Cross Formation, Center Element
if(Formation == "Cross" && Center == "Yes")
    [crossXY] = SwarmWithCenter(CROSS,SWARM_RADIUS);
    pentXY = 0;
end
%Cross Formation, No Center Element
if(Formation == "Cross" && Center == "No")
    [crossXY] = SwarmNoCenter(CROSS,SWARM_RADIUS);
    pentXY = 0;
end

%------------------------------------------------------

%Pentagon Formation, Center Element
if(Formation == "Pentagon" && Center == "Yes")
    [pentXY] = SwarmWithCenter(PENT,SWARM_RADIUS);
    crossXY = 0;
end
%Cross Formation, No Center Element
if(Formation == "Pentagon" && Center == "No")
    [pentXY] = SwarmNoCenter(PENT,SWARM_RADIUS);
    crossXY = 0;
end
end

