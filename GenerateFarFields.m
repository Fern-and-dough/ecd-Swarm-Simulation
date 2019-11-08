%Name:          GenerateFarFields
%Description:   This function Generates Far Field patterns for the original 
%               beam direction.
%--------------------------------------------------------------------------
%INPUT:         -TO DO-
%--------------------------------------------------------------------------               
%OUTPUT:        -TO DO-
%--------------------------------------------------------------------------
function [crossField,pentField] = GenerateFarFields(Formation,...
                                                    crossXY,pentXY,...
                                                    crossZ,pentZ,...
                                                    FREQUENCY,...
                                                    NUM_CROSS,NUM_PENT)

if(Formation == "Cross")
    crossField = CalcFarField(crossXY, crossZ, FREQUENCY, NUM_CROSS);
    pentField = 0;
end
if(Formation == "Pentagon")
    pentField = CalcFarField(pentXY, pentZ, FREQUENCY, NUM_PENT);
    crossField = 0;
end
if(Formation == "Both")
    crossField = CalcFarField(crossXY, crossZ, FREQUENCY, NUM_CROSS);
    pentField = CalcFarField(pentXY, pentZ, FREQUENCY, NUM_PENT);
end
end

