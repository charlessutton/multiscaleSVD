function [pulse] = stair_pulse(I, starting_point, pulse_width)
    D = length(I);
    start_point_idx = find(I > starting_point,1);    
    end_point_idx = find(I>starting_point+pulse_width,1);
    pulse = zeros(1,D);
    pulse(1,start_point_idx:end_point_idx) = 1;
end