% Main Script
% 
% Authors: Sharang Phadke
%          Christian Sherland
%          Sameer Chauhan
%          
%
% Date: 3-20-13
%
% Project: Speech Processing Signal Segmentation
% 

clear all
close all
init;
globalVar;

%% Get Features from Data
loadTrainingDataOld
loadDevelopmentDataOld
% load training.mat
% load development.mat
% load fullDevelopment.mat

numCeps = 13;

%% Train a classifier
% make a feature matrix
training_Ceps = cell2mat(trainingCeps);
train_Features = [training_Ceps(:,1:numCeps) cell2mat(train_Centroid)...
    cell2mat(train_STEnergy) cell2mat(train_Loud)]; %cell2mat(train_SpecSpar)];
trainingLabels2 = labelExpand(trainingLabel,train_Centroid);

% Create PRT Dataset
trainingDataSet = prtDataSetClass(train_Features,trainingLabels2);

% Pre-process the Dataset
% Preprocessor = prtPreProcPls;   % try different preprocessing techniques
% Preprocessor = Preprocessor.train(trainingDataSet);
% trainingDataSetProcessed = Preprocessor.run(trainingDataSet);

% Classifier Setup
classifier = prtClassBinaryToMaryOneVsAll;          % Create a classifier
classifier.baseClassifier = prtClassGlrt;           % Set the binary classifier
classifier.internalDecider = prtDecisionMap;        % Set the internal decider
classifier = classifier.train(trainingDataSet);     % Train

% Try another classifier?
% classifier = prtClassKnn;
% classifier = classifier.train(trainingDataSet);

% Segment Development Data and Get Features
[segments, fsDev, segTimes] = detectVoiced(devScriptPath);
[segFeatures segLabels] = getFeatures(segments,fs,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'NUMCEPS',numCeps);
segDataSet = prtDataSetClass(segFeatures,segLabels);

%% Segmented Development Data from Annotations
dev_Ceps = cell2mat(devCeps);
dev_Features = [dev_Ceps(:,1:numCeps) cell2mat(devCentroid)...
    cell2mat(devSTE) cell2mat(devLoudness)]; %cell2mat(devSpecSpar)];
devLabels2 = labelExpand(devLabels,devCentroid);
devDataSet = prtDataSetClass(dev_Features,devLabels2);

%% Classify Data and Evaluate Results
segClasses = run(classifier, segDataSet);
devClasses = run(classifier, devDataSet);

segPercentCorr = prtScorePercentCorrect(segClasses.getX,segDataSet.getTargets)
devPercentCorr = prtScorePercentCorrect(devClasses.getX,devDataSet.getTargets)
