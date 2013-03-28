% Authors: Christian Sherland
%          Sameer Chauhan
%          Sharang Phadke
%
% Date: 2-20-13
%
% Project: Speech Processing Signal Segmentation
%
% Bugs: Potential issue using some of the same data for training and
%       testing
%

clear;
clc;

%% Generate Training Data for Events

%Get structures containing all pertinent file names 
trainingSoundFiles = dir('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/*.wav');
trainingSoundAnnot = dir('../Datasets/Office Live/singlesounds_annotation/Annotation2/*.txt');

%Read time tags for training set
fid = fopen('../Datasets/Office Live/events_OL_development/annotation1/script01_bdm.txt');
testDataLabelCell = textscan(fid,'%f%f%s','delimiter','\t');
fclose(fid);

%Read training dataset sound file
[y,fs] = wavread('../Datasets/Office Live/events_OL_development/bformat/script01-01.wav');
startPad= [testDataLabelCell{1}; length(y)/fs];

ceps  = zeros(length(trainingSoundFiles) + length(testDataLabelCell{1}),13);
label = zeros(length(trainingSoundFiles) + length(testDataLabelCell{1}),1);

%Read signals in one at a time
%and feed to hmm to avoid memory overflow
for ii = 1:length(trainingSoundFiles)
   %the iith signal
   [traData,fs] = wavread(strcat('../Datasets/Office Live/singlesounds_stereo/singlesounds_stereo/',trainingSoundFiles(ii).name));
   
   %the iith signal identification tag
   fid = fopen(strcat('../Datasets/Office Live/singlesounds_annotation/Annotation2/',trainingSoundAnnot(ii).name));
   traAnnot = textscan(fid,'%f%f','delimiter','\t');
   fclose(fid);
   
   %extracted signal and name of event
   pureTrainingSignal = traData(ceil(traAnnot{1}(1)*fs)+1:floor(traAnnot{2}(1)*fs)-1,1);
   trainingSignalLabel = trainingSoundAnnot(ii).name(1:find(isletter(trainingSoundAnnot(ii).name)==0,1,'first')-1);
   
   %Extract signal features here
   ceps(ii,:) = mean(mfcc(pureTrainingSignal,fs),2)';
   label(ii) = 1;
end

%Parse testing data signals upon tags
for ii = 1 : length(testDataLabelCell{1})
   start  = floor(testDataLabelCell{2}(ii)*fs);
   finish = ceil(startPad(ii+1)*fs);   
   
   %Extract signal features here
   ceps(ii+length(trainingSoundFiles),:) = mean(mfcc(y(start:finish),fs),2)';
end

trainingDataSet = prtDataSetClass(ceps,label);

%% Read and Segment Test File (Generate True Event Labels for Comparisson)

%Read time tags for training set
fid = fopen('../Datasets/Office Live/events_OL_development/annotation1/script01_bdm.txt');
testDataLabelCell = textscan(fid,'%f%f%s','delimiter','\t');
fclose(fid);

%Read training dataset sound file
[y,fs] = wavread('../Datasets/Office Live/events_OL_development/bformat/script01-01.wav');

frameLength = fs*.01;
%numberSubdivisions = floor(length(y)/(fs*0.01)); % 1 frame every 100th of a second
%actualSignals = cell(numberSubdivisions,1);

%Parse training data signals upon tags (off by one error is annoying here)
%for ii = 0 : numberSubdivisions-1
%   actualSignals{ii+1} = y(floor(ii*fs*0.01)+1:floor((ii+1)*fs*0.01));
%end
actualSignals = buffer(y,frameLength)';

%remake ceps and label for test dataSet
%ceps  = zeros(numberSubdivisions,13);
%label = zeros(numberSubdivisions,1);
ceps = melfcc(y,fs,'wintime',0.01);
label = zeros(size(ceps,2),1);

times = 0:.01:length(y)/fs;

tic

for ii = 1:length(testDataLabelCell{1})
    ind = find((times >= testDataLabelCell{1}(ii)).*(times <= testDataLabelCell{2}(ii))); 
    label(ind) = 1;
end

toc
% isEvent = 0;
% nextTime = testDataLabelCell{1}(1);
% wasFrom = 1;
% whichElement = 1;
% notAtEnd = true;


%Determine relavant features for each signal.
%for ii = 1 : numberSubdivisions
%    ceps(ii,:) = mean(mfcc(actualSignals{ii},fs),2)';
%    
%    if ((ii-1)*fs*0.01 > nextTime && notAtEnd)
%        
%        if(isEvent == 1)
%           isEvent = 0; 
%        else
%           isEvent = 1; 
%        end
%        
%        if(wasFrom == 1)
%           wasFrom = 2; 
%        else
%           wasFrom = 1;
%            whichElement = whichElement + 1;
%         end
%         
%         if(whichElement == numel(testDataLabelCell{1}))
%            notAtEnd = false; 
%         end
%         
%         nextTime = testDataLabelCell{wasFrom}(whichElement);
%     end
%     
%     label(ii) = isEvent; 
% end


testingDataSet = prtDataSetClass(ceps',label);

%% Train Classifier and Apply to Test DataSet

classifier = prtClassGlrt;                          % Set the binary                                             
classifier.internalDecider = prtDecisionBinaryMinPe;% Set the internal Decider
 
classifier = classifier.train(trainingDataSet);     % Train
classes    = run(classifier, testingDataSet);       % Test
 
% Evaluate, plot results
percentCorr = prtScorePercentCorrect(classes.getX,testingDataSet.getTargets);
disp('Signal Segmented')

%% Make two vectors for starting and stoping times of events


