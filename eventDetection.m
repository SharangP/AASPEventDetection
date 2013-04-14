function eventDetection(inputFile, outputFile )
%EVENTDETECTION takes inputFile as input and attempts
%   to detect event within the input .wav file. Detected
%   events are written to the path of outputFile

devScriptPath = inputFile;
outputFilePath = outputFile;
pointOhOne = 0.05;
% devScriptPath = '../Datasets/Office Live/events_OL_development/stereo/script01.wav';
devAnnotPath = '../Datasets/Office Live/events_OL_development/annotation2/script01_sid.txt';

%% Get Features from Data

fprintf('Extracting features ... ')
% loadTrainingData
% loadDevelopmentData
load training.mat
load development.mat
fprintf('Done.\n\n')

%% Create Training Dataset

fprintf('Generating training dataset ... ')
trainingLabels2 = labelExpand(trainingLabels,trainingFeatures);
trainingDS = prtDataSetClass(cell2mat(trainingFeatures),trainingLabels2);
trainingDS = trainingDS.setClassNames(getClassName(1:16));
fprintf('Done.\n\n')

%% Classifier Setup

fprintf('Training classifier ... ')
classifier = prtClassBinaryToMaryOneVsAll;
classifier.baseClassifier = prtClassGlrt;
classifier = classifier + prtDecisionMap;
classifier = classifier.train(trainingDS);
fprintf('Done.\n\n')

%% Segment Development Data and Create Dataset

[segments, segFs, segTimes] = detectVoiced(devScriptPath);
[segFeatures, segLabels, segLabelsExpanded] = getFeatures(segments,segFs,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'CELL');
segDS = prtDataSetClass(cell2mat(segFeatures),segLabelsExpanded);
segDS = segDS.setClassNames(getClassName(unique(segLabelsExpanded)));

%% Create Perfectly Segmented Development Dataset

devLabels2 = labelExpand(devLabels,devFeatures);
devDS = prtDataSetClass(cell2mat(devFeatures),devLabels2);
devDS = devDS.setClassNames(getClassName(unique(devLabels)));

%% Classify Data and Evaluate Results

fprintf('Running frame by frame classification ... ')
segClasses = run(classifier, segDS);
devClasses = run(classifier, devDS);
fprintf('Done.\n\n')

segPercentCorr = prtScorePercentCorrect(segClasses.getX,segDS.getTargets);
devPercentCorr = prtScorePercentCorrect(devClasses.getX,devDS.getTargets);
fprintf('segPercentCorr: %f\n',segPercentCorr);
fprintf('devPercentCorr: %f\n\n',devPercentCorr);

% figure(1)
% prtScoreConfusionMatrix(segClasses.getX,segDS.getTargets);
% title('Classifier Confusion Matrix With Segmenter');
% xticklabel_rotate([],45);
% align(figure(1),'center','center');
% 
% figure(2)
% prtScoreConfusionMatrix(devClasses.getX,devDS.getTargets);
% title('Classifier Confusion Matrix Without Segmenter');
% xticklabel_rotate([],45);
% align(figure(2),'center','center');

fprintf('Running event classification ... ')
classes = determineClasses(segClasses.getX,segTimes,pointOhOne);
% classes = consolidateClasses(segClasses, segFeatures);
fprintf('Done.\n\n')

fprintf('Writing output ... ')
writeOutput(outputFilePath, segTimes, classes);
fprintf('Done.\n\n')

end

