%% configurations
pat = [0 0 0 1];
len = 300;
M = 12;
A = 11;
PHSTEP = 64;

%% initialization
pulse_in = repmat(pat, 1, len);

%% run
pulse_out = zeros(1, length(pulse_in));
for i = 1:length(pat)*len
    pulse_out(i) = rc(pulse_in(i), M, A);
end

%% analysis
phase_in = pulse_in;
for i=2:length(phase_in)
    phase_in(i) = mod(phase_in(i-1) + pulse_in(i), PHSTEP);
end

phase_out = pulse_out;
for i=2:length(pulse_out)
    phase_out(i) = mod(phase_out(i-1) + pulse_out(i), PHSTEP);
end

pulse_ideal = repmat(pat .* (M/A), 1, len);
phase_ideal = pulse_ideal;
for i=2:length(pulse_out)
    phase_ideal(i) = mod(phase_ideal(i-1) + pulse_ideal(i), PHSTEP);
end

plot(mod(phase_out-phase_ideal, PHSTEP), 'ro');
hold on;
plot(mod(phase_in-phase_ideal, PHSTEP), 'x');


