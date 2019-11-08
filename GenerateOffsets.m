%Name:          GenerateOffsets
%Description:   This section is to show the effects of misplaced antennas
%               in the x, y, and z positions. It will be a randomly 
%               generated offset between -1 and 1 which will be multiplied
%               by MAX_ERROR_ALLOWED.
%--------------------------------------------------------------------------
%INPUT:         -TO DO-
%--------------------------------------------------------------------------               
%OUTPUT:        -TO DO-
%--------------------------------------------------------------------------
function [cross_offset_pos, cross_offset_field,...
    pent_offset_pos,pent_offset_field] = GenerateOffsets(Offset,Center,...
                                                crossXY, pentXY,...
                                                crossZ, pentZ,...
                                                MAX_ERROR_ALLOWED,...
                                                FREQUENCY, NUM_DRONES)
                                      
if (Center == "No")
    CROSS = 4;
    PENT = 5;
else
    CROSS = 5;
    PENT = 6;
end
                                            
if(Offset == "Cross")
    [cross_offset_pos, cross_offset_field] = OffsetFarField(crossXY,...
                                                            crossZ,...
                                                            MAX_ERROR_ALLOWED,...
                                                            FREQUENCY, CROSS);
    pent_offset_pos = 0;
    pent_offset_field = 0;
end 

% Need to UPDATE OffsetFarField Function for Pentagon Offsets 

if(Offset == "Pentagon") 
    [pent_offset_pos, pent_offset_field] = OffsetFarField(pentXY,...
                                                            pentZ,...
                                                            MAX_ERROR_ALLOWED,...
                                                            FREQUENCY, PENT);
    cross_offset_pos = 0;
    cross_offset_field = 0;
end

if(Offset == "Both")
    [cross_offset_pos, cross_offset_field] = OffsetFarField(crossXY,...
                                                            crossZ,...
                                                            MAX_ERROR_ALLOWED,...
                                                            FREQUENCY, CROSS);
    [pent_offset_pos, pent_offset_field] = OffsetFarField(pentXY,...
                                                            pentZ,...
                                                            MAX_ERROR_ALLOWED,...
                                                            FREQUENCY, PENT);    
end
end

