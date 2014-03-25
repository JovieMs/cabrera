clear;clc;

%% PRBS Polynomials and resolutions
res_array = 5:7;
poly_cell = {
    [7 6 0]
    [8 6 5 4 0]
    [9 5 0]
    [10 7 0]
    [11 9 0]
    [12 11 8 6 0]
    [13 12 10 9 0]
    [14 13 8 4 0]
    [15 14 0]};

%% looping
for i = 1:size(poly_cell, 1)
    for j = 1:length(res_array)
        
        POLY = poly_cell{i};
        RES = res_array(j);
        len = 2^max(POLY) - 1;

        h = commsrc.pn('GenPoly', POLY, 'NumBitsOut', RES);

        r = zeros(1, len);
        %h.CurrentStates
        for k=1:len
            bits = generate(h)';
            r(k) = sum(bits .* (2 .^ (-1:-1:-RES)));
        end
        %h.CurrentStates

        exp_mean = sum(2 .^ (-1:-1:-RES)) / 2;
        act_mean = mean(r);

        %% accumulator; 1-tap IIR
        y = filter(1, [1 -1], r-act_mean);
        figure;
        set(gcf, 'Position', [0 0 900 400])
        subplot(1,2,1);
        hist(r-act_mean, 20);
        title({'histogram of r - actual mean'
            ['actual mean = ' num2str(act_mean) '; expected mean = ' num2str(exp_mean)]});
        subplot(1,2,2);
        plot(y(1:len)); grid on;
        title({['1-tap IIR accumulator']
            ['poly = [' num2str(POLY) ']; ' 'resolution = ' num2str(RES)]
            });
    end
end

%%
close all;
