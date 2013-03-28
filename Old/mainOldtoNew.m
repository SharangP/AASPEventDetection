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
% loadTrainingDataOld
% loadDevelopmentDataOld
load training.mat
load development.mat
% load fullDevelopment.mat

numCeps = 13;

%% Train a classifier
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);
trainingDataSet = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);

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
[segFeatures segLabels] = getFeatures(segments,fsDev,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'NUMCEPS',numCeps);
segDataSet = prtDataSetClass(segFeatures,segLabels);

%% Segmented Development Data from Annotations
devLabels2 = labelExpand(devLabels,devFeatures);
devDataSet = prtDataSetClass(cell2mat(devFeatures),devLabels2);

%% Classify Data and Evaluate Results
segClasses = run(classifier, segDataSet);
devClasses = run(classifier, devDataSet);

segPercentCorr = prtScorePercentCorrect(segClasses.getX,segDataSet.getTargets)
devPercentCorr = prtScorePercentCorrect(devClasses.getX,devDataSet.getTargets)
