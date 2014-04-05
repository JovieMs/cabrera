clc;clear;close all;

%% configurations
PHSTEP = 64;
Aj = PHSTEP/8;
M = 24;
A = 11;

fj = 1;
fjr = fj*2^12;
t = 0:1/fjr:2^2/fj;
jitter = Aj * sin(2*pi*fj*t);

%%
jitter_pulse_raw = floor(jitter);
jitter_pulse_in = jitter_pulse_raw(2:end) - jitter_pulse_raw(1:end-1);
pat = [0 0 0 1];
pulse_in = jitter_pulse_in + repmat(pat, [1, length(jitter_pulse_in)/length(pat)]);
%pulse_in = repmat(pat, [1, length(jitter_pulse_in)/length(pat)]);



%% run
pulse_out = zeros(1, length(pulse_in));
pulse_out_dither = zeros(1, length(pulse_in));
for i = 1:length(pulse_in)
    pulse_out(i) = rc(pulse_in(i), M, A, 'none');
    pulse_out_dither(i) = rc(pulse_in(i), M, A, 'prbs');
end

%% pulse shaping output comparisons
disp_len = 1:200;
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

pulse_ideal = pulse_in * M / A;
phase_ideal = pulse_ideal;
for i=2:length(phase_ideal)
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

t = 1:length(pulse_out_filt)/1;
figure;
plot(t, pulse_out_filt(t), '-bo', t, pulse_out_dither_filt(t), '-rx');
legend('phase out filter', 'phase out w/ dither filter');

%%
pulse_out_freq = pulse_out(end-2^14+1:end);
pulse_out_freq = pulse_out_freq - mean(pulse_out_freq);
pulse_out_dither_freq = pulse_out_dither(end-2^14+1:end);
pulse_out_dither_freq = pulse_out_dither_freq - mean(pulse_out_dither_freq);
NFFT = 2^(nextpow2(length(pulse_out_freq)-1));
z0 = fft(pulse_out_freq, NFFT);
z1 = fft(pulse_out_dither_freq, NFFT);
z0 = abs(z0(1:NFFT/2+1));
z1 = abs(z1(1:NFFT/2+1));
f = 463.5/2*linspace(0, 1, NFFT/2+1);

t = 1:length(z0);
figure;
plot(f(t), z0(t), '-o', f(t), z1(t), ':rx');
legend('without dithering', 'with dithering');

(var(z0)-var(z1))/var(z1)*100


