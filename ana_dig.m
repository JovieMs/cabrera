clc;clear;

%%
N = 16;
pat = [zeros(1, N-1) 1];
len = 16000;
M = 12;
A = 11;
PHSTEP = 64;

pulse = repmat(pat, 1, len);
%pulse = 1/8 * (rand(1, length(pulse))-0.5) + pulse;
phase = filter(1, [1 -1], pulse);

%%
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
NFFT = 2^15;
z = abs(fft(y, NFFT));
z = z(1:NFFT/2+1);
zj = abs(fft(y_jitter, NFFT));
zj = zj(1:NFFT/2+1);

f = Fs/2*linspace(0, 1, NFFT/2+1);

t = 1:length(z)/2;
figure;
plot(f(t), z(t), '-x', f(t), zj(t), ':ro');
legend('w/o jitter', 'w/ jitter');

