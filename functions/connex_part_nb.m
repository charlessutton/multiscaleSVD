function [ cc ] = connex_part_nb( stair_pulse )
% compute the number of separated blocks
    flattened_stair_pulse = stair_pulse ;
    flattened_stair_pulse(flattened_stair_pulse>0) = 1;
    diff_stair_pulse = diff(flattened_stair_pulse);
    % for each block there is exactly one +1
    cc = sum(diff_stair_pulse==1);
end