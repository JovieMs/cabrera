clc;clear;

%% configurations
N = 32;
pat = [zeros(1, N-1) 1];
len = 16000;
M = 12;
A = 11;
PHSTEP = 64;

pulse_in = repmat(pat, 1, len);
phase_in = filter(1, [1 -1], pulse_in);

%% run
pulse_out = zeros(1, length(pulse_in));
pulse_out_dither = zeros(1, length(pulse_in));
for i = 1:length(pat)*len
    pulse_out(i) = rc(pulse_in(i), M, A, 'none');
    pulse_out_dither(i) = rc(pulse_in(i), M, A, 'prbs');
end

phase_out = filter(1, [1 -1], pulse_out);
phase_out_dither = filter(1, [1 -1], pulse_out_dither);

%%
phase = phase_in;

F = 2^7;    % nominal frequency
Fs = F*PHSTEP;  % sampling frequency
Fj = 2^4;

w = 2*pi*F;
t = 0:1/Fs:1000/F;
jitter = sin(2*pi*Fj*t);
y = sin((w+1/64/N*pi*2*Fs)*t);
y_jitter = sin(w*t+phase(1:length(t))/PHSTEP*2*pi);

%%
k = 1:200;
plot(1000*t(k), y(k), '-x', 1000*t(k), y_jitter(k), '-ro');
legend('w/o jitter', 'w/ jitter');
xlabel('ms');

%%
% NFFT = 2^15;
% z = abs(fft(y, NFFT));
% z = z(1:NFFT/2+1);
% zj = abs(fft(y_jitter, NFFT));
% zj = zj(1:NFFT/2+1);
% 
% f = Fs/2*linspace(0, 1, NFFT/2+1);
% 
% t = 1:length(z)/2;
% figure;
% plot(f(t), z(t), '-x', f(t), zj(t), ':ro');
% legend('w/o jitter', 'w/ jitter');