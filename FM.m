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
carrierAmplitude = 5;

%Obtain phi(t)
integratedSignal = cumsum(resampledSignal)/carrierSampleRate;
integratedSignal = integratedSignal * kf;
integratedSignal = integratedSignal.';

%Obtain the carrier signal
carrierTimeStep = 1 / carrierSampleRate;
carrierSignal = 0:carrierTimeStep:length(resampledSignal)/carrierSampleRate - 1/carrierSampleRate;
carrierSignal = carrierSampleRate * carrierSignal * 2 * pi;

%Do modulation
modulatedSignal = cos(carrierSignal + integratedSignal) * carrierAmplitude;

%Add noise to the modulated signal
modulatedSignal = awgn(modulatedSignal, 200);

%Demodulate the signal
demodulatedSignal = fmdemod(modulatedSignal, 100000, 200000, deltaOmega);

%Plot the demodulated signal
plot(demodulatedSignal);

%Down sample the signal to use the sound function
demodulatedSignal = resample(demodulatedSignal, signalSampleRate, carrierSampleRate);
sound(demodulatedSignal, signalSampleRate);