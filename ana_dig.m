pat = [0 0 0 1];
len = 1600;
M = 12;
A = 11;
PHSTEP = 64;

%% initialization
pulse_in = repmat(pat, 1, len);

phase_in = pulse_in;
for i=2:length(phase_in)
    phase_in(i) = mod(phase_in(i-1) + pulse_in(i), PHSTEP);
end

plot(phase_in)
f = 2^7;    % nominal frequency
fs = f*PHSTEP;  % sampling frequency

phase = filter(1, [1 -1], repmat([0 0 0 0 1], 1, 13));

w = 2*pi*f;
t = 0:1/fs:1/f;
y = sin(w*t+phase/PHSTEP*2*pi);
plot(1000*t, y, '-x');
xlabel('ms');


