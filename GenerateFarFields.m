%Name:          GenerateFarFields
%Description:   This function Generates Far Field patterns for the original 
%               beam direction.
%--------------------------------------------------------------------------
%INPUT:         -TO DO-
%--------------------------------------------------------------------------               
%OUTPUT:        -TO DO-
%--------------------------------------------------------------------------
function [crossField,pentField] = GenerateFarFields(Formation,Center,...
                                                    crossXY,pentXY,...
                                                    crossZ,pentZ,...
                                                    FREQUENCY,NUM_DRONES)

%# of drones needed in each swarm
if (Center == "No")
    CROSS = 4;
    PENT = 5;
else
    CROSS = 5;
    PENT = 6;
end

if(Formation == "Cross")
    crossField = CalcFarField(crossXY, crossZ, FREQUENCY, CROSS);
    pentField = 0;
end
if(Formation == "Pentagon")
    pentField = CalcFarField(pentXY, pentZ, FREQUENCY, PENT);
    crossField = 0;
end
if(Formation == "Both")
    crossField = CalcFarField(crossXY, crossZ, FREQUENCY, CROSS);
    pentField = CalcFarField(pentXY, pentZ, FREQUENCY, PENT);
end
end

