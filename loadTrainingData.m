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

% initialize some things
trainingLabels = zeros(length(trainingSoundFiles),1);
trainingFeatures = cell(length(trainingSoundFiles),1);

for ii = 1:length(trainingSoundFiles)
   % Extract the iith signal
   [Signal,fs] = wavread(strcat('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/',trainingSoundFiles(ii).name));
   
   % Extract the iith signal identification tag
   fid = fopen(strcat('../Datasets/Office Live/singlesounds_annotation/Annotation2/',trainingSoundAnnot(ii).name));
   Annot = textscan(fid,'%f%f','delimiter','\t');
   fclose(fid);
   
   % Extract signal and name of event, then get the event #
   pureTrainingSignal = Signal(ceil(Annot{1}(1)*fs)+1:floor(Annot{2}(1)*fs)-1,1);
   trainingSignalLabel = trainingSoundAnnot(ii).name(1:find(isletter(trainingSoundAnnot(ii).name)==0,1,'first')-1);
   trainingLabels(ii) = getClassNum(trainingSignalLabel);
   
   % Extract signal features
   trainingFeatures{ii} = getFeatures(pureTrainingSignal,fs,pointOhOne);   
   
end

% save features and labels
fname = './MAT files/training.mat';
save(fname,'trainingLabels','trainingFeatures');