%% configurations
pat = [0 0 0 0 0 0 1];
len = 1000;
PHSTEP = 64;

%% initialization
pulse_in = repmat(pat, 1, len);

%% run
pulse_out = zeros(1, length(pulse_in));
for i = 1:length(pat)*len
    pulse_out(i) = rc(pulse_in(i), 12, 11);
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

plot(mod(phase_out-phase_in, PHSTEP));


%%


