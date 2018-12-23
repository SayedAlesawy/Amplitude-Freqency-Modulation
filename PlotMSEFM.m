function [] = PlotMSEFM(size)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    axis([0 20 0 0.5]);
    errors = zeros(size+1, 1);
    SNRs = zeros(size+1, 1);
    idx = 1;
    
    for i = 0:size
        SNRs(idx) = i;
        errors(idx) = FMLogic(i);
        message = sprintf('Error at SNR = %d is %f', i, errors(idx));
        disp(message);
        idx = idx + 1;
    end
    
    plot(SNRs, errors, '*b');
end