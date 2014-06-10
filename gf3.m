clc;clear;

lsfr = ones(1, 16);

len = 2^13;
a = zeros(1, len);
for i=1:len
    a(i) = mod(-sum(2*lsfr(1:2)) - sum(lsfr(4:5)), 3);
    lsfr(1:15) = lsfr(2:16);
    lsfr(16) = a(i);
end
hist(a)
b = a - 1;
autocorr(b, 100);