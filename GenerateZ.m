%Name:          GenerateZ
%Description:   Generates z positions for each of the antennas by implementing
%               eq 30. This equation assumes we are in the far field.
%--------------------------------------------------------------------------
%INPUT:         Formation ("*Cross*", "Pentagon", or "Both")
%               crossXY (Either xy coordinates of each antenna or 0)
%               pentXY (Either xy coordinates of each antenna or 0)
%               BEAM_DIRECTION (Desired BEAM_DIRECTION)
%               FEQUENCY (Operating Frequency)
%               NUM_DRONES (# of Drones in Swarm)
%--------------------------------------------------------------------------               
%OUTPUT:        crossZ (Returns crossZ antenna positions, or 0)
%               pentZ(Returns pentZ antenna positions, or 0)
%
%NOTE: All Asterisk options are default form values
%--------------------------------------------------------------------------               
function [crossZ,pentZ] = GenerateZ(Formation,...
                                    crossXY,pentXY,...
                                    BEAM_DIRECTION,...
                                    FREQUENCY,...
                                    NUM_CROSS,NUM_PENT)

if(Formation == "Cross")
    crossZ = CalcZPos(crossXY, BEAM_DIRECTION, FREQUENCY, NUM_CROSS);
    pentZ = 0;
end
if(Formation == "Pentagon")
    pentZ = CalcZPos(pentXY, BEAM_DIRECTION, FREQUENCY, NUM_PENT);
    crossZ = 0;
end
if(Formation == "Both")
    crossZ = CalcZPos(crossXY, BEAM_DIRECTION, FREQUENCY, NUM_CROSS);
    pentZ = CalcZPos(pentXY, BEAM_DIRECTION, FREQUENCY, NUM_PENT);
end
end

