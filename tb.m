clc;clear;

%% configurations
pat = [0 0 0 1];
len = 80;
M = 12;
A = 11;
PHSTEP = 64;

%% initialization
pulse_in = repmat(pat, 1, len);

%% run
pulse_out = zeros(1, length(pulse_in));
pulse_out_dither = zeros(1, length(pulse_in));
for i = 1:length(pat)*len
    pulse_out(i) = rc(pulse_in(i), M, A, 'none');
    pulse_out_dither(i) = rc(pulse_in(i), M, A, 'prbs');
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

phase_out_dither = pulse_out_dither;
for i=2:length(pulse_out_dither)
    phase_out_dither(i) = mod(phase_out_dither(i-1) + pulse_out(i), PHSTEP);
end

pulse_ideal = repmat(pat .* (M/A), 1, len);
phase_ideal = pulse_ideal;
for i=2:length(pulse_out)
    phase_ideal(i) = mod(phase_ideal(i-1) + pulse_ideal(i), PHSTEP);
end

phase_out_vs_ideal = mod(phase_out-phase_ideal, PHSTEP);
phase_out_dither_vs_ideal = mod(phase_out_dither-phase_ideal, PHSTEP);
phase_in_vs_ideal = mod(phase_in-phase_ideal, PHSTEP);

t = phase_out_vs_ideal >= 32;
phase_out_vs_ideal(t) = phase_out_vs_ideal(t) - 64;
t = phase_out_dither_vs_ideal >= 32;
phase_out_dither_vs_ideal(t) = phase_out_dither_vs_ideal(t) - 64;
t = phase_in_vs_ideal >= 32;
phase_in_vs_ideal(t) = phase_in_vs_ideal(t) - 64;

t = 1:length(phase_out_vs_ideal);
plot(t, phase_out_vs_ideal, 'ro', t, phase_out_dither_vs_ideal, '-x');
legend('phase out vs ideal', 'phase out w/ dither vs ideal');

%%
phase_delta = pulse_out_dither - pulse_out;
subplot(2,1,1)
plot(t, pulse_out, 'bo')
subplot(2,1,2)
plot(t, pulse_out_dither, 'ro')