% Christian Sherland
% 2-13-13
% ECE411 - Speech Processing Project 1 (
%
%
%   Analysis of provided OfficeLive Sampleset.
%
%

fid = fopen('script01_bdm.txt');
data = textscan(fid,'%f%f%s','delimiter','\t');
fclose(fid);

[y,fs] = wavread('script01-01.wav');

actualSignals = {};

for ii = 1 : length(data{1})
   actualSignals{ii} = y(ceil(data{1}(ii)*fs):ceil(data{2}(ii)*fs));
end

spectrogram(actualSignals{12},triang(256),128,1024,'yaxis')