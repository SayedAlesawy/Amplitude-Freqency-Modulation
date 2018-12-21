function [ err ] = AMLogic( SNR )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %Read the audio file
    [originalSignal, signalSampleRate] = audioread('SpeechDFT-16-8-mono-5secs.wav');

    %Test that the audio file has been read
    %sound(originalSignal, signalSampleRate);
    axis([0 1e6 -1 1]);

    %To be able to modulate the signal with a carrier frequency of 100 KHz
    %We will need to choose a sampling frequency of 200 KHz according to
    %Nyquist theorem. So we will also need to resample the sound signal
    %to match the sample rate of the carrier signal

    %Define the carrier signal parameters
    modulationIndex = 0.9;
    carrierSampleRate = 200000;
    carrierAmplitude = abs(min(originalSignal)) / modulationIndex;
    carrierTimeStep = 1 / carrierSampleRate;

    %Resample the original signal to 200 KHz
    resampledSignal = resample(originalSignal, carrierSampleRate, signalSampleRate);

    %Define the carrier signal
    carrierSignal = 0:carrierTimeStep:length(resampledSignal)/carrierSampleRate - 1/carrierSampleRate;

    %Do AM modulation DSB-LC
    modulatedSignal = (carrierAmplitude + resampledSignal) .* cos(2*pi*carrierSignal).';

    %Add noise to the signal
    modulatedSignal = awgn(modulatedSignal, SNR);

    %Do demodulation using an envlope detector
    [lower, higher] = envelope(modulatedSignal);
    demodulatedSignal = lower - mean(lower);
    plot(demodulatedSignal);

    %Down sample the signal to use the sound function
    demodulatedSignal = resample(demodulatedSignal, signalSampleRate, carrierSampleRate);
    %sound(demodulatedSignal, signalSampleRate);

    %Calculate the mean square error
    err = mse(originalSignal, demodulatedSignal);
end

