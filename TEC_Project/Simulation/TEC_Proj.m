clc; clear; close all;

H_highpass = designfilt('highpassiir', 'FilterOrder', 8, 'HalfPowerFrequency', 0.3);

[y, Fs] = audioread('/Users/apple/Documents/ترم۳/Electrical_Circuit_Project/required_files/audio1_cut.wav');
[y2, ~] = audioread('/Users/apple/Documents/ترم۳/Electrical_Circuit_Project/required_files/audio2_cut.wav');

upsample_factor = 3;
y_upsampled = interp(y, upsample_factor);
y_upsampled2 = interp(y2, upsample_factor);
Fs_upsampled = Fs * upsample_factor;

numSamples = length(y_upsampled2);
frequency = 440;
amplitude = 5;
t = (0:numSamples-1) / Fs_upsampled;
y_upsampled2 = y_upsampled2 + amplitude * cos(2 * pi * frequency * t');

N_upsampled = length(y_upsampled);
t_upsampled = (0:N_upsampled-1) / Fs_upsampled;
w = 2 * pi * 11000;
y_cos = y_upsampled .* cos(w * t_upsampled');
y_cos = filter(H_highpass, y_cos);
y_sum = y_cos + y_upsampled2;

y_sum = y_sum / max(abs(y_sum));
audiowrite('/Users/apple/Documents/ترم۳/Electrical_Circuit_Project/required_files/output_signalsum.wav', y_sum, Fs_upsampled);

tosim = timeseries(y_sum, t');

disp('Starting Simulink simulation...');

simOut = sim('/Users/apple/Documents/ترم۳/Electrical_Circuit_Project/required_files/untitled.slx'); 
disp('Simulation finished!');


signal_output   = simOut.simout.Data;
signal_lowpass  = simOut.y_lowpass.Data;
signal_bandpass = simOut.y_bandpass.Data;


audiowrite('/Users/apple/Documents/ترم۳/Electrical_Circuit_Project/required_files/output_signal1_simulink.wav', signal_output, Fs_upsampled);
audiowrite('/Users/apple/Documents/ترم۳/Electrical_Circuit_Project/required_files/output_signal2_simulink.wav', signal_lowpass, Fs_upsampled);
disp('All audio files saved successfully!');


sound(signal_output, Fs_upsampled);