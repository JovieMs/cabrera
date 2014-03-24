function [ pulse_out ] = rc( pulse_in, M, A )
%RC Summary of this function goes here
%   Rate convertion
persistent intp;

if isempty(intp)
   intp = 0;
end

intp = intp + pulse_in * M + 1*(rand()-0.5);
pulse_out = floor(intp/A);
intp = mod(intp, A);

end