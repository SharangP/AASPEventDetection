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
Class1 = [1 4 5 6 7 10 15];
Class2 = [8 9 13 14 16];
% Items in class 3 are equally confused between class 1 and 2
Class3 = [2 3 11 12];


%% Create Training Dataset
% Create the Training Dataset
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);

% reassign class labels into one of three classes
trainingLabels2(ismember(trainingLabels2,Class1)) = 17;
trainingLabels2(ismember(trainingLabels2,Class2)) = 18;
trainingLabels2(ismember(trainingLabels2,Class3)) = 19;
trainingLabels2 = trainingLabels2 - 16;

trainingDS = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);
% trainingDS = trainingDS.setClassNames(getClassName(1:16));
% trainingDS = trainingDS.retainFeatures([1:45]);

%% Classifier Setup
classifier = prtClassKnn + prtDecisionMap;          % Create a classifier
% trainingL = classifier.kfolds(trainingDS,10);          % Train
% [~,trainingClasses] = max(trainingL.getObservations,[],2);
% figure(3)
% prtScoreConfusionMatrix(trainingClasses,trainingDS.getTargets);

classifier = classifier.train(trainingDS);

%% Segment Development Data and Create Dataset
[segments, segFs, segTimes] = detectVoiced(devScriptPath);
[segFeatures, segLabels, segLabelsExpanded] = getFeatures(segments,segFs,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'CELL');

segLabelsExpanded(ismember(segLabelsExpanded,Class1)) = 17;
segLabelsExpanded(ismember(segLabelsExpanded,Class2)) = 18;
segLabelsExpanded(ismember(segLabelsExpanded,Class3)) = 19;
segLabelsExpanded(segLabelsExpanded > 0) = segLabelsExpanded(segLabelsExpanded > 0) - 16;

segDS = prtDataSetClass(cell2mat(segFeatures),segLabelsExpanded);
segDS = segDS.setClassNames(getClassName(unique(segLabelsExpanded)));
% segDS = segDS.retainFeatures(retainedFeatures);

%% Create Perfectly Segmented Development Dataset
devLabels2 = labelExpand(devLabels,devFeatures);

devLabels2(ismember(devLabels2,Class1)) = 17;
devLabels2(ismember(devLabels2,Class2)) = 18;
devLabels2(ismember(devLabels2,Class3)) = 19;
devLabels2(devLabels2 > 0) = devLabels2(devLabels2 > 0) - 16;

devDS = prtDataSetClass(cell2mat(devFeatures),devLabels2);
devDS = devDS.setClassNames(getClassName(unique(devLabels)));
% devDS = devDS.retainFeatures(retainedFeatures);

%% Classify Data and Evaluate Results
segClasses = run(classifier, segDS);
devClasses = run(classifier, devDS);

% [~, segL] = max(segClasses.getX,[],2);
% [~, devL] = max(devClasses.getX,[],2);

segPercentCorr = prtScorePercentCorrect(segClasses.getTargets,segDS.getTargets)
devPercentCorr = prtScorePercentCorrect(devClasses.getTargets,devDS.getTargets)

figure(1)
prtScoreConfusionMatrix(segClasses,segDS);
% title('Classifier Confusion Matrix With Segmenter');
xticklabel_rotate([],45);
align(figure(1),'center','center');

figure(2)
prtScoreConfusionMatrix(devClasses,devDS);
% title('Classifier Confusion Matrix Without Segmenter');
xticklabel_rotate([],45);
align(figure(2),'center','center');
