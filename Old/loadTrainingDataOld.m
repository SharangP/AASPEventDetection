% Get Features from Training Data
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


%Get structures containing all pertinent file names 
trainingSoundFiles = dir('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/*.wav');
trainingSoundAnnot = dir('../Datasets/Office Live/singlesounds_annotation/Annotation2/*.txt');

trainingCeps = cell(length(trainingSoundFiles),1);
trainingLabel = zeros(length(trainingSoundFiles),1);
train_STEnergy = cell(length(trainingSoundFiles),1);
train_Centroid = cell(length(trainingSoundFiles),1);
train_Loud = cell(length(trainingSoundFiles),1);
train_SpecSpar = cell(length(trainingSoundFiles),1);
trainingFeatures = cell(length(trainingSoundFiles),1);

for ii = 1:length(trainingSoundFiles)
   %the iith signal
   [traSignal,fs] = wavread(strcat('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/',trainingSoundFiles(ii).name));
   
   %the iith signal identification tag
   fid = fopen(strcat('../Datasets/Office Live/singlesounds_annotation/Annotation2/',trainingSoundAnnot(ii).name));
   traAnnot = textscan(fid,'%f%f','delimiter','\t');
   fclose(fid);
   
   %extracted signal and name of event
   pureTrainingSignal = traSignal(ceil(traAnnot{1}(1)*fs)+1:floor(traAnnot{2}(1)*fs)-1,1);
   trainingSignalLabel = trainingSoundAnnot(ii).name(1:find(isletter(trainingSoundAnnot(ii).name)==0,1,'first')-1);

%    looking at them spectrograms

%    if(sum(ismember(x-2,ii)))
%        figure(1)
%        subplot(4,4,find(ismember(x-2,ii)))
%        spectrogram(pureTrainingSignal,triang(fs*.01),0,256,fs,'yaxis')
%        title(trainingSignalLabel)
%    end
%    
%    if(sum(ismember(x,ii)))
%        figure(2)
%        subplot(4,4,find(ismember(x,ii)))
%        spectrogram(pureTrainingSignal,triang(fs*.01),0,256,fs,'yaxis')
%        title(trainingSignalLabel)
%    end
   
   %Extract signal features here
   trainingCeps{ii} = melfcc(pureTrainingSignal,fs,'wintime',pointOhOne,'hoptime',pointOhOne)';
   trainingLabel(ii) = getClassNum(trainingSignalLabel);
   train_STEnergy{ii} = ShortTimeEnergy(pureTrainingSignal,pointOhOne*fs, pointOhOne*fs)';
   train_Centroid{ii}= SpecCentroid(pureTrainingSignal,pointOhOne*fs, 0 ,pointOhOne*fs)';
   train_Loud{ii} = loudness(pureTrainingSignal, pointOhOne*fs)';
   train_SpecSpar{ii} = spectralSparsity(pureTrainingSignal, pointOhOne*fs, fs)';
   % Each Cell has
   % Loudness, Centroid, Spectral Sparsity, Short Time Energy, MFCC's
    trainingFeatures{ii} = [train_Loud{ii} train_Centroid{ii} train_SpecSpar{ii} train_STEnergy{ii} trainingCeps{ii}];
   
   
end

% save features and labels
fname = './MAT files/trainingOld.mat';
save(fname,'trainingCeps', 'trainingLabel', 'train_Centroid', 'train_STEnergy', 'train_Loud', 'train_SpecSpar', 'trainingFeatures');