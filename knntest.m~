% knn testing to see groupings in events

clear all
close all

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

%%
knnClassifier = prtClassKnn;
knnClassifier = knnClassifier.train(trainingDS);
res = knnClassifier.kfolds(trainingDS,10); %10-Fold cross-validation
