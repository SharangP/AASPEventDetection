% Load Development Data
% Perform perfect segmentation using annotation file
% 
% Authors: Christian Sherland
%          Sameer Chauhan
%          Sharang Phadke
%
% Date: 2-27-13
%
% Project: Speech Processing Signal Segmentation
%
% Bugs: 
% 
globalVar;
numFeatures = 13;

%Read time tags for dev set
fid = fopen('../Datasets/Office Live/events_OL_development/annotation1/script01_bdm.txt');
devAnnots = textscan(fid,'%f%f%s','delimiter','\t');
fclose(fid);

%Read dev dataset sound file
[fullDev,fs] = wavread('../Datasets/Office Live/events_OL_development/bformat/script01-01.wav');

devSignals = cell(length(devAnnots{1}),1);
devCeps = cell(length(devAnnots{1}),1);
devLabels = zeros(length(devAnnots{1}),1);

% get features of full signal
fullDevCeps = melfcc(fullDev,fs,'wintime',pointOhOne,'hoptime',pointOhOne,'numcep',numFeatures)';
fullDevSTE = ShortTimeEnergy(fullDev,pointOhOne*fs, pointOhOne*fs)';
fullDevCentroid = SpecCentroid(fullDev,pointOhOne*fs, 0 ,pointOhOne*fs)';
fullDevLoudness = loudness(fullDev, pointOhOne*fs)';
fullDevSpecSpar = spectralSparsity(fullDev, pointOhOne*fs, fs)';
fullDevLabel = zeros(length(fullDevCeps),1);

% get features of events
devSTE = cell(length(devAnnots{1}),1);
devCentroid = cell(length(devAnnots{1}),1);
devLoudness = cell(length(devAnnots{1}),1);
devSpecSpar = cell(length(devAnnots{1}),1);

times = 0:pointOhOne:length(fullDev)/fs;
%Parse dev data signals with annotation tags
for ii = 1 : length(devAnnots{1})
   devSignals{ii} = fullDev(ceil(devAnnots{1}(ii)*fs):ceil(devAnnots{2}(ii)*fs));
   devLabels(ii) = getClassNum(devAnnots{3}(ii));
   devCeps{ii} = melfcc(devSignals{ii},fs,'wintime',pointOhOne,'hoptime',pointOhOne)';
   
   devSTE{ii} = ShortTimeEnergy(devSignals{ii},pointOhOne*fs,pointOhOne*fs)';
   devCentroid{ii} = SpecCentroid(devSignals{ii},pointOhOne*fs,0,pointOhOne*fs)';
   devLoudness{ii} = loudness(devSignals{ii}, pointOhOne*fs)';
   devSpecSpar{ii} = spectralSparsity(devSignals{ii}, pointOhOne*fs, fs)';

   ind = find((times >= devAnnots{1}(ii)).*(times <= devAnnots{2}(ii))); 
   fullDevLabel(ind) = 1;
end


fname = './MAT files/developmentOld.mat';
save(fname,'devSignals','devAnnots','devLabels','devCeps','devSTE','devCentroid','devLoudness','devSpecSpar');
fname2 = './MAT files/fullDevelopmentOld.mat';
save(fname2,'fullDev','fullDevLabel','fullDevCeps','fullDevSTE','fullDevCentroid','fullDevLoudness','fullDevSpecSpar','fs');