% knn testing to see groupings in events

clear all
close all

%% Get Features from Data
% loadTrainingData
% loadDevelopmentData
load training.mat
load development.mat

retainedFeatures = [1:18];


%% Create Training Dataset
% % Create the Training Dataset
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);
trainingDS = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);
trainingDS = trainingDS.setClassNames(getClassName(1:16));
trainingDS = trainingDS.retainFeatures(retainedFeatures);



% 
% %%
% knnClassifier = prtClassKnn;
% knnClassifier = knnClassifier.train(trainingDS);
% res = knnClassifier.kfolds(trainingDS,10); %10-Fold cross-validation

%% try culstering
clusterAlgo = prtClusterGmm;      % Create a prtClusterKmeans object
clusterAlgo.nClusters = 3;           % Set the number of desired clusters

% Set the internal decision rule to be MAP. Not required for
% clustering, but necessary to plot the results.
clusterAlgo.internalDecider = prtDecisionMap;
clusterAlgo = clusterAlgo.train(trainingDS); % Train the cluster algorithm
% plot(clusterAlgo);                   % Plot the results
C = run(clusterAlgo,trainingDS);
prtScoreConfusionMatrix(C.getX,trainingDS.getTargets)