clc;clear;

%% configurations
pat = [0 0 0 1];
len = 5050;
M = 12;
A = 11;
PHSTEP = 64;
jitter = [  repmat([zeros(1, 100) 1], [1 50]), repmat([zeros(1, 100) -1], [1 50]) repmat([zeros(1, 100) 1], [1 50]), repmat([zeros(1, 100) -1], [1 50])];

%% initialization
pulse_in = repmat(pat, 1, len);
%pulse_in = jitter;


%% run
pulse_out = zeros(1, length(pulse_in));
pulse_out_dither = zeros(1, length(pulse_in));
for i = 1:length(pat)*len
    pulse_out(i) = rc(pulse_in(i), M, A, 'none');
    pulse_out_dither(i) = rc(pulse_in(i), M, A, 'float');
end

%% pulse shaping output comparisons
disp_len = 1:80;
figure;
set(gcf, 'Position', [0 0 900 400])
subplot(2,1,1)
plot(disp_len, pulse_out(disp_len), 'bo')
title('RC pulse output without dithering');
subplot(2,1,2)
plot(disp_len, pulse_out_dither(disp_len), 'ro');
title('RC pulse output with dithering');

%% phase accumulation
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
    phase_out_dither(i) = mod(phase_out_dither(i-1) + pulse_out_dither(i), PHSTEP);
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

%% comparison between with dither and without dither
t = 1:length(phase_out_vs_ideal);
figure;
plot(t, phase_out_vs_ideal, '-ro', t, phase_out_dither_vs_ideal, '-x');
legend('phase out vs ideal', 'phase out w/ dither vs ideal');

%% TX PI jitter filter
b = 2^-10;
a = [1 -(1-b)];
pulse_out_dither_filt = filter(b, a, pulse_out_dither);
pulse_out_filt = filter(b, a, pulse_out);

t = 1:length(pulse_out_filt);
figure;
plot(t, pulse_out_filt, '-b', t, pulse_out_dither_filt, '-r');
legend('phase out filter', 'phase out w/ dither filter');

