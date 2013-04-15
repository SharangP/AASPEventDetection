function eventDetection(inputFile, outputFile )
%EVENTDETECTION takes inputFile as input and attempts
%   to detect event within the input .wav file. Detected
%   events are written to the path of outputFile

init;
inputFile = inputFile;
pointOhOne = 0.05;

%% Get Features from Data

fprintf('Loading training features ... ')
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

fprintf('Segmenting input and extracting features ... ')
[segments, segFs, segTimes] = detectVoiced(inputFile);
[segFeatures, ~, segLabelsExpanded] = getFeatures(segments,segFs,pointOhOne,...
    'TIMES',segTimes,'ANNOTS',devAnnots,'CELL');
segDS = prtDataSetClass(cell2mat(segFeatures),segLabelsExpanded);
fprintf('Done.\n\n')

%% Classify Data and Write Output

fprintf('Running frame by frame classification ... ')
segClasses = run(classifier, segDS);
fprintf('Done.\n\n')

segPercentCorr = prtScorePercentCorrect(segClasses);
fprintf('percent correct: %f\n',segPercentCorr)

figure(1)
prtScoreConfusionMatrix(segClasses.getX,segDS.getTargets);
title('Classifier Confusion Matrix With Segmenter');
xticklabel_rotate([],45);
align(figure(1),'center','center');

fprintf('Running event classification ... ')
classes = determineClasses(segClasses.getX,segTimes,pointOhOne);
fprintf('Done.\n\n')

fprintf('Writing output ... ')
writeOutput(outputFile, segTimes, classes);
fprintf('Done.\n\n')

end

