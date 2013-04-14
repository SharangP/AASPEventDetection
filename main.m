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
fprintf('START: feature extraction stage\n')
% loadTrainingData
% loadDevelopmentData
load training.mat
load development.mat
% retainedFeatures = [1:40];
fprintf('FINISH: feature extraction stage\n')
%% Create Training Dataset
% Create the Training Dataset
fprintf('Generating training dataset\n')
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);
trainingDS = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);
trainingDS = trainingDS.setClassNames(getClassName(1:16));
% trainingDS = trainingDS.retainFeatures(retainedFeatures);

%% Pre-process the Dataset
%Preprocessor = prtPreProcPca('nCFomponents',27);   % try different preprocessing techniques
%Preprocessor = Preprocessor.train(trainingDS);
% trainingDS = Preprocessor.run(trainingDS);

%% Classifier Setup
classifier = prtClassBinaryToMaryOneVsAll;
classifier.baseClassifier = prtClassGlrt;
classifier = classifier + prtDecisionMap;
% classifier.internalDecider = prtDecision;        % Set the internal decider
% classifier.rvs = prtRvGmm;
% mAry_classifier = prtClassBinaryToMaryOneVsAll;          % Create a classifier
% mAry_classifier.baseClassifier =    prtClassRvmFigueiredo ;
% classifier= prtPreProcZmuv  + mAry_classifier + prtDecisionMap;

fprintf('Training classifier...')
classifier = classifier.train(trainingDS);
fprintf('Done\n')

%% Segment Development Data and Create Dataset
[segments, segFs, segTimes] = detectVoiced(devScriptPath);
[segFeatures, segLabels, segLabelsExpanded] = getFeatures(segments,segFs,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'CELL');

segDS = prtDataSetClass(cell2mat(segFeatures),segLabelsExpanded);
segDS = segDS.setClassNames(getClassName(unique(segLabelsExpanded)));

% segDS = segDS.retainFeatures(retainedFeatures);
% segDS = Preprocessor.run(segDS);

%% Create Perfectly Segmented Development Dataset
devLabels2 = labelExpand(devLabels,devFeatures);

devDS = prtDataSetClass(cell2mat(devFeatures),devLabels2);
devDS = devDS.setClassNames(getClassName(unique(devLabels)));

% devDS = devDS.retainFeatures(retainedFeatures);
% devDS = Preprocessor.run(devDS);

%% Classify Data and Evaluate Results
segClasses = run(classifier, segDS);
devClasses = run(classifier, devDS);

% segClasses = consolidateClasses(segClasses,segFeatures);
% devClasses = consolidateClasses(devClasses,devFeatures);

segPercentCorr = prtScorePercentCorrect(segClasses.getX,segDS.getTargets);
devPercentCorr = prtScorePercentCorrect(devClasses.getX,devDS.getTargets);

% segGuess = markovTraceBack(segClasses.getX,C,occ);
% devGuess = markovTraceBack(devClasses.getX,C,occ);

% figure(1)
% prtScoreConfusionMatrix(segGuess,segDS.getTargets);
% title('Classifier Confusion Matrix With Segmenter');
% xticklabel_rotate([],45);
% align(figure(1),'center','center');

% figure(2)
% prtScoreConfusionMatrix(devGuess,devDS.getTargets);
% title('Classifier Confusion Matrix Without Segmenter');
% xticklabel_rotate([],45);
% align(figure(2),'center','center');

figure(1)
prtScoreConfusionMatrix(segClasses.getX,segDS.getTargets);
% title('Classifier Confusion Matrix With Segmenter');
xticklabel_rotate([],45);
align(figure(1),'center','center');

figure(2)
prtScoreConfusionMatrix(devClasses.getX,devDS.getTargets);
% title('Classifier Confusion Matrix Without Segmenter');
xticklabel_rotate([],45);
align(figure(2),'center','center');

save('./resultsGlrtMAPAutoCorr.mat', 'segClasses', 'segDS', 'devClasses', 'devDS', 'classifier');
