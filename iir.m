%%
N = 16;
pat = [zeros(1, N-1) 1];
len = 16000;
M = 12;
A = 11;
PHSTEP = 64;

pulse = repmat(pat, 1, len);

%%
b = 2^-10;
a = [1 -(1-b)];
pulse_flt = filter(b, a, pulse);

t = 1:length(pulse_flt)/20;
figure;
plot(t, pulse_flt(t), '--bx');
legend('phase out filter');