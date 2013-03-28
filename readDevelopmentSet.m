% Christian Sherland
% 2-13-13
% ECE411 - Speech Processing Project 1 
%
%
%   Analysis of provided OfficeLive Sampleset.
%
%

%Read time tags for training set
fid = fopen('../Datasets/Office Live/events_OL_development/annotation1/script01_bdm.txt');
data = textscan(fid,'%f%f%s','delimiter','\t');
fclose(fid);

%Read training dataset sound file
[y,fs] = wavread('../Datasets/Office Live/events_OL_development/bformat/script01-01.wav');

actualSignals = {};     %eventually preallocate for efficiency 

%Parse training data signals upon tags
for ii = 1 : length(data{1})
   actualSignals{ii} = y(ceil(data{1}(ii)*fs):ceil(data{2}(ii)*fs));
end

%spectrogram(actualSignals{12},triang(256),128,1024,'yaxis')

ceps = {};              %eventually preallocate for efficiency 

%Determine relavant features for each signal.
for ii = 1 : length(actualSignals)
    ceps{ii} = mfcc(actualSignals{ii}, fs); %These are probably useless.
end

%Now I have features. Wut do I do?
%Maybe use locboost to find better features?



