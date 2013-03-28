% Christian Sherland
% 2-28-13
% Single Class SVM Signal Segmentation

clear;
clc;
globalVar;
cd .
numFeatures = 3;
load devFeatures.mat;
load training.mat;

train_mfcc = cellfun(@(x) x(:,1:numFeatures), trainingCeps, 'UniformOutput', false);

trainFeature = [train_STEnergy train_Centroid] ;
devFeature =[devSTE devCentroid];
trainFraction =0.3;
testFraction = 0.2;
%% Get Training Data and Generate Training DataSet

% %Get structures containing all pertinent file names 
% trainingSoundFiles = dir('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/*.wav');
% trainingSoundAnnot = dir('../Datasets/Office Live/singlesounds_annotation/Annotation2/*.txt');
% 
% % ceps  = zeros(length(trainingSoundFiles),numFeatures);
% % label = zeros(length(trainingSoundFiles),1);
% trainingSegCeps = cell(length(trainingSoundFiles),1);


%Read signals in one at a time
%and feed to hmm to avoid memory overflow
disp('Extracting Features...');
% for ii = 1:length(trainingSoundFiles)
%    %the iith signal
%    [traData,fs] = wavread(strcat('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/',trainingSoundFiles(ii).name));
%    
%    %the iith signal identification tag
%    fid = fopen(strcat('../Datasets/Office Live/singlesounds_annotation/Annotation2/',trainingSoundAnnot(ii).name));
%    traAnnot = textscan(fid,'%f%f','delimiter','\t');
%    fclose(fid);
%    
%    %extracted signal and name of event
%    pureTrainingSignal = traData(ceil(traAnnot{1}(1)*fs)+1:floor(traAnnot{2}(1)*fs)-1,1);
%    trainingSignalLabel = trainingSoundAnnot(ii).name(1:find(isletter(trainingSoundAnnot(ii).name)==0,1,'first')-1);
%    
%    %Extract signal features here
% %    ceps(ii,:) = mean(melfcc(pureTrainingSignal,fs,'wintime',pointOhOne,'hoptime',pointOhOne,'numcep',numFeatures)');
%     trainingSegCeps{ii} = melfcc(pureTrainingSignal,fs,'wintime',pointOhOne,'hoptime',pointOhOne,'numcep',numFeatures)';
% %    label(ii) = 1;
% end


% ceps = cell2mat(cellfun(@(x) x(:,1:numFeatures), trainingCeps, 'UniformOutput', false));
ceps = cell2mat(trainFeature);
tempLength = round(trainFraction*length(ceps));
label = ones(length(ceps),1);
trainingDataSet = prtDataSetClass(ceps(1:tempLength,:),label(1:tempLength));

%% Get Test Data
disp('Get Testing Data....');
% %Read time tags for training set
% fid = fopen('../Datasets/Office Live/events_OL_development/annotation1/script01_bdm.txt');
% testDataLabelCell = textscan(fid,'%f%f%s','delimiter','\t');
% fclose(fid);
% 
% %Read training dataset sound file
% [y,fs] = wavread('../Datasets/Office Live/events_OL_development/bformat/script01-01.wav');
% 
% %Get features for segmented signal
% ceps = melfcc(y,fs,'wintime',pointOhOne,'hoptime',pointOhOne,'numcep',numFeatures);
% label = zeros(size(ceps,2),1);
% 
% times = 0:.01:length(y)/fs;
% 
% %Define Labels for each feature segment (event/no event)
% for ii = 1:length(testDataLabelCell{1})
%     ind = find((times >= testDataLabelCell{1}(ii)).*(times <= testDataLabelCell{2}(ii))); 
%     label(ind) = 1;
% end

tempLength2 = round(testFraction*length(fullDevLabel));
testingDataSet = prtDataSetClass(devFeature(1:tempLength2,:),fullDevLabel(1:tempLength2));

%% Create a Single Class SVM based upon trainingDataSet and run on testingDataSet
disp('Training Classifier....')
classifier = prtClassLibSvm('svmType',2);
classifier = classifier.train(trainingDataSet);                    %This seems to have worked.

disp('Done Training');
% Create decider and choose probability of detection. 
decider = prtDecisionOneClassPd;
decider.pd = .25;
classifier.internalDecider = decider;

disp('Running Classifier...');
%Test on data. 
classifier = run(classifier, testingDataSet);                      %Problem
% plot(trainingDataSet)

% figure()
% plot(testingDataSet)

%classifier.plot
percentCorr = prtScorePercentCorrect(classifier,testingDataSet);
prtScoreConfusionMatrix(classifier,testingDataSet);
disp('Done');

