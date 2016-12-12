% HRTF Demo  -  3D Sound Generation - Azimuth Only
%
% Use an academic HRIR (frequency response at various source angles, both
% elevation and azimuthal) to generate an HRTF for a source at a given
% point in space. 

clear all;
close all;

%
% Load the HRTF/HRIR library to be used.
% The first is the academic one, the second is a rough, manually measured
% one from our team's head model / simulator.  (Generated from measured
% frequency response?)

load('IRC_1002_C_HRIR.mat');
%load('HRIR_head_simulator');

% Set sampling frequency from loaded library.
fs = l_eq_hrir_S.sampling_hz;
%(note: the sampling frequency is the same for both ears)
% may need to look into adjusting this

%
% Input desired HRTF/HRIR azimuth and elevation. Note that no check occurs
% to confirm that the combination of requested azimuth and elevation exist
% in the library being used.
% I can add that check!
% 

% HRIR_idx = HRTF_gen(azimuth, elevation);
%  the [l_eq_hrir_S.azim_v] == azimuth returns a vector contatining ones 
%  and zeros corresponding to the presence or absence of the value
%  'azimuth' in each location of l_eq_hrir_S.azim_v
%
%  find() returns the coordinates of the 1's in each vector
%
%  intersect then returns the common data between the two, which is the
%  index needed for the HRIR

% Generate sine tone for use as a reference source signal.
t = [0:fs-1]/fs;  % may need to use element by element operations?
tone_freq = 500;
sig = sin(2*pi()*tone_freq*t);

% Alternately, an anechoic mono source file may be used. Resampling step
% included to ensure HRTF and source file sampling frequencies match.

% [sig, sig_fs] = audioread('trumpet.wav');
% sig = resample(sig,fs,sig_fs);

% Play back reference signal and wait to avoid overlapping playback.
soundsc(sig,fs);
pause((length(sig)/fs)+0.5);

% generate figure to visualize azimuthal angle
% hold on enables appending to figure
% polaraxes enabled
fig1 = figure('Name','Source Location','NumberTitle','Off');
pax = polaraxes;
% p.Marker = '*';
% p.MarkerSize = 8;
rlim([0 1.2]);
hold on;

for k = 0:23
    azimuth = 15*k;
    elevation = 0;

    % Find index of HRTF at requested azimuth and elevation.
    HRIR_idx = intersect(find([l_eq_hrir_S.azim_v] == azimuth),find([l_eq_hrir_S.elev_v] == elevation));
    
    % theta = 0:0.01:2*pi;
    theta = (15*k + 90) * (pi / 180);
    % rho = sin(2*theta).*cos(2*theta);
    %rho = cos(elevation);
    rho = 1;
    polarplot(theta,rho,'*');

    % Convolve HRIR with reference signal and play back.
    binaural_L = conv(sig,l_eq_hrir_S.content_m(HRIR_idx,:));
    binaural_R = conv(sig,r_eq_hrir_S.content_m(HRIR_idx,:));
    binaural_sig = [binaural_L; binaural_R];
    soundsc(binaural_sig,fs);
    pause((length(sig)/fs)+0.2);

end





