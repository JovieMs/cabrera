function [ disturb ] = dither( )
%DITHER Summary of this function goes here
%   Generate dithering in range (-0.5, 0.5)

RES = 7;
POLY = [15 14 0];
ACT_MEAN = 0.4987;

persistent h;

if isempty(h)
   h = commsrc.pn('GenPoly', POLY, 'NumBitsOut', RES);
end

bits = generate(h)';

disturb = sum(bits .* (2 .^ (-1:-1:-RES))) - ACT_MEAN;

end

