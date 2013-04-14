%% Get Features from Data
% loadTrainingData
% loadDevelopmentData
load training.mat
load development.mat

numCeps = 13;
retainedFeatures = [1:19];

%% Create Training Dataset
% Create the Training Dataset
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);
trainingDS = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);
trainingDS = trainingDS.setClassNames(getClassName(1:16));
trainingDS = trainingDS.retainFeatures(retainedFeatures);

%% Classifier Setup
classifier = prtClassBinaryToMaryOneVsAll;          % Create a classifier
classifier.baseClassifier = prtClassGlrt;           % Set the binary classifier
classifier.internalDecider = prtDecisionMap;        % Set the internal decider
classifier = classifier.train(trainingDS);          % Train

%% Create Perfectly Segmented Development Dataset
devLabels2 = labelExpand(devLabels,devFeatures);
devDS = prtDataSetClass(cell2mat(devFeatures),devLabels2);
devDS = devDS.setClassNames(getClassName(unique(devLabels)));
devDS = devDS.retainFeatures(retainedFeatures);

%% Classify Data and Evaluate Results
devClasses = run(classifier, devDS);

devPercentCorr = prtScorePercentCorrect(devClasses.getX,devDS.getTargets)

figure(2)
prtScoreConfusionMatrix(devClasses,devDS);
title('Classifier Confusion Matrix Without Segmenter');
xticklabel_rotate([],45);
align(figure(2),'center','center');