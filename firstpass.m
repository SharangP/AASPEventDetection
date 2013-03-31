% First Pass Classification
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
% close all
init;
globalVar;

%% Get Features from Data
% loadTrainingData
% loadDevelopmentData
load training.mat
load development.mat

numCeps = 13;
% retainedFeatures = [1:19];

% classNames = {'alert','clearthroat','cough','doorslam','knock','drawer',
% 'keyboard','keys','laughter','mouse','pageturn','pendrop','phone',
% 'printer','speech','switch'}';
% Items in each class often get confused with each other (they are similar)
% Class1 = [1 4 5 6 7 10 15];
% Class2 = [8 9 13 14 16];
% % Items in class 3 are equally confused between class 1 and 2
% Class3 = [2 3 11 12];


%% Create Training Dataset
% Create the Training Dataset
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);

% reassign class labels into one of three classes
% trainingLabels2(ismember(trainingLabels2,Class1)) = 17;
% trainingLabels2(ismember(trainingLabels2,Class2)) = 18;
% trainingLabels2(ismember(trainingLabels2,Class3)) = 19;
% trainingLabels2 = trainingLabels2 - 16;

trainingDS = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);
trainingDS = trainingDS.setClassNames(getClassName(1:16));
% trainingDS = trainingDS.retainFeatures(retainedFeatures);

%% Pre-process the Dataset
% Preprocessor = prtPreProcPls;   % try different preprocessing techniques
% Preprocessor = Preprocessor.train(trainingDS);
% trainingDataSetProcessed = Preprocessor.run(trainingDS);

%% Classifier Setup
classifier = prtClassKnn;          % Create a classifier
% classifier = prtClassBinaryToMaryOneVsAll;          % Create a classifier
% classifier.baseClassifier = prtClassGlrt;           % Set the binary classifier
% classifier.internalDecider = prtDecisionMap;        % Set the internal decider
classifier = classifier.train(trainingDS);          % Train


%% Segment Development Data and Create Dataset
[segments, segFs, segTimes] = detectVoiced(devScriptPath);
[segFeatures, segLabels, segLabelsExpanded] = getFeatures(segments,segFs,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'CELL');
segDS = prtDataSetClass(cell2mat(segFeatures),segLabelsExpanded);
segDS = segDS.setClassNames(getClassName(unique(segLabelsExpanded)));
% segDS = segDS.retainFeatures(retainedFeatures);

%% Create Perfectly Segmented Development Dataset
devLabels2 = labelExpand(devLabels,devFeatures);
devDS = prtDataSetClass(cell2mat(devFeatures),devLabels2);
devDS = devDS.setClassNames(getClassName(unique(devLabels)));
% devDS = devDS.retainFeatures(retainedFeatures);

%% Classify Data and Evaluate Results
segClasses = run(classifier, segDS);
devClasses = run(classifier, devDS);
trainingClasses = run(classifier,trainingDS);

[~, segL] = max(segClasses.getX,[],2);
[~, devL] = max(devClasses.getX,[],2);
[~, trainingL] = max(trainingClasses.getX,[],2);

segPercentCorr = prtScorePercentCorrect(segL,segDS.getTargets)
devPercentCorr = prtScorePercentCorrect(devL,devDS.getTargets)
trainingPercentCorr = prtScorePercentCorrect(trainingL,trainingDS.getTargets)

figure(1)
prtScoreConfusionMatrix(segL,segDS.getTargets);
title('Classifier Confusion Matrix With Segmenter');
xticklabel_rotate([],45);
align(figure(1),'center','center');

figure(2)
prtScoreConfusionMatrix(devL,devDS.getTargets);
title('Classifier Confusion Matrix Without Segmenter');
xticklabel_rotate([],45);
align(figure(2),'center','center');

figure(3)
prtScoreConfusionMatrix(trainingL,trainingDS.getTargets);
