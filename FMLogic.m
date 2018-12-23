function [ err ] = FMLogic( SNR )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
   
    %Read the audio file
    [originalSignal, signalSampleRate] = audioread('SpeechDFT-16-8-mono-5secs.wav');
    originalSignal = originalSignal.';
    
    %Resample the input signal
    carrierFreqency = 100000;
    carrierSampleRate = 300000;
    resampledSignal = resample(originalSignal, carrierSampleRate, signalSampleRate);

    %Define modulation parameters
    modulationIndex = 5;
    deltaOmega = modulationIndex * (signalSampleRate/2); 
    signalAmplitude = max(resampledSignal);
    kf = (deltaOmega*2*pi)/signalAmplitude;
    carrierAmplitude = 1;

    %Obtain phi(t)
    integratedSignal = cumsum(resampledSignal)/carrierSampleRate;
    integratedSignal = integratedSignal * kf;

    %Obtain the carrier signal
    carrierTimeStep = 1 / carrierSampleRate;
    carrierSignal = 0:carrierTimeStep:length(resampledSignal)/carrierSampleRate - 1/carrierSampleRate;
    carrierSignal = carrierFreqency * carrierSignal * 2 * pi;

    %Do modulation
    modulatedSignal = cos(carrierSignal + integratedSignal) * carrierAmplitude;

    %Add noise to the modulated signal
    modulatedSignal = awgn(modulatedSignal, SNR);

    %Demodulate the signal
    demodulatedSignal = fmdemod(modulatedSignal, carrierFreqency, carrierSampleRate, deltaOmega);

    %Plot the demodulated signal
    axis([0 1e6 -1 1]);
    plot(demodulatedSignal);

    %Down sample the signal to use the sound function
    demodulatedSignal = resample(demodulatedSignal, signalSampleRate, carrierSampleRate);
    sound(demodulatedSignal, signalSampleRate);
    
    %calculate the MSE
    err = mse(originalSignal, demodulatedSignal);
end
