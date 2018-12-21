%Read the audio file
[originalSignal, signalSampleRate] = audioread('SpeechDFT-16-8-mono-5secs.wav');

%Test that the audio file has been read
%sound(originalSignal, signalSampleRate);
%axis([0 1e6 -1 1]);

%sound(originalSignal, signalSampleRate);

%Resample the input signal
carrierSampleRate = 800000;
resampledSignal = resample(originalSignal, carrierSampleRate, signalSampleRate);

%Define modulation parameters
modulationIndex = 5;
deltaOmega = modulationIndex * carrierSampleRate; 
signalAmplitude = max(abs(min(resampledSignal)), max(resampledSignal));
kf = deltaOmega / signalAmplitude;
integratedSignal = cumsum(resampledSignal);
integratedSignal = integratedSignal * kf;
%disp(length(integratedSignal));
carrierTimeStep = 1 / carrierSampleRate;

%Do modulation
carrierSignal = 0:carrierTimeStep:length(resampledSignal)/carrierSampleRate - 1/carrierSampleRate;
carrierSignal = carrierSampleRate * carrierSignal * 2 * pi;
integratedSignal = integratedSignal.';
modulatedSignal = cos(carrierSignal + integratedSignal);

%Add noise to the modulated signal
modulatedSignal = awgn(modulatedSignal, 200);

%Demodulate the signal
demodulatedSignal = fmdemod(modulatedSignal, 100000, 200000, deltaOmega);

%Plot the demodulated signal
plot(demodulatedSignal);

%Down sample the signal to use the sound function
demodulatedSignal = resample(demodulatedSignal, signalSampleRate, carrierSampleRate);
sound(demodulatedSignal, signalSampleRate);