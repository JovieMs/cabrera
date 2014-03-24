clear;clc;

RES = 7;
POLY = [15 14 0];
len = 2^max(POLY) - 1;

h = commsrc.pn('GenPoly', POLY, 'NumBitsOut', RES);

r = zeros(1, len);
h.CurrentStates
for i=1:len
    bits = generate(h)';
    r(i) = sum(bits .* (2 .^ (-1:-1:-RES)));
end
h.CurrentStates

exp_mean = sum(2 .^ (-1:-1:-RES)) / 2;
act_mean = mean(r);

%% moving average
y = filter(1, [1 -1], r-act_mean);
plot(y(1:len))