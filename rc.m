function [ pulse_out ] = rc( pulse_in, M, A, dithering )
%RC Summary of this function goes here
%   Rate convertion

persistent intp;
persistent intp_dither_float;
persistent intp_dither_prbs;

if isempty(intp)
   intp = 0;
end

if isempty(intp_dither_float)
   intp_dither_float = 0;
end

if isempty(intp_dither_prbs)
   intp_dither_prbs = 0;
end

if(strcmp(dithering, 'none'))
    intp = intp + pulse_in * M;
    pulse_out = floor(intp/A);
    intp = mod(intp, A);
elseif(strcmp(dithering, 'float'))
    intp_dither_float = intp_dither_float + pulse_in * M + M/16*(rand()-0.5);
    pulse_out = floor(intp_dither_float/A);
    intp_dither_float = mod(intp_dither_float, A);
elseif(strcmp(dithering, 'prbs'))
    intp_dither_prbs = intp_dither_prbs + pulse_in * M + M/32*dither();
    pulse_out = floor(intp_dither_prbs/A);
    intp_dither_prbs = mod(intp_dither_prbs, A);
end


end