% HMM test
% 
% Authors: Christian Sherland
%          Sameer Chauhan
%          Sharang Phadke
%
% Date: 2-27-13
%
% Project: Speech Processing Signal Segmentation
%
% Bugs: 
%

clear all;
globalVar
load training.mat
load development.mat

ceps = trainingFeatures;
label = trainingLabels;
%% hmm things
numStates = 3*ones(1,16); % for each event, # of states
numFeatures = 5; 

G1 = repmat(prtRvMvn('sigma',eye(numFeatures),'covarianceStructure','diagonal'),numStates(1),1);
G2 = repmat(prtRvMvn('sigma',eye(numFeatures),'covarianceStructure','diagonal'),numStates(end),1);
learnHmm1 = prtRvHmm('components',G1);
learnHmm2 = prtRvHmm('components',G2);

HMMS = [repmat(learnHmm1,14,1) ; repmat(learnHmm2,2,1)];

%% Train HMMs
disp('start training')

eventSetStart = [1; find(diff(label))];
eventSetEnd = [find(diff(label)); length(label)];


for n = 1:length(eventSetStart)
    disp(n)
    features = cellfun(@(x) x(:,1:numFeatures), ceps(eventSetStart(n):eventSetEnd(n)), 'UniformOutput', false);
    
    ds = prtDataSetTimeSeries(features);
    HMMS(n) = HMMS(n).mle(ds);
end

%% testing for percent correct on dev set
test = zeros(length(HMMS),1);
results = zeros(length(devCeps),1);
features2 = cellfun(@(x) x(:,1:numFeatures), devCeps, 'UniformOutput', false);

for m = 1:length(features2)
    ds2 = prtDataSetTimeSeries(features2(m));
        for n = 1:length(HMMS)
%             disp(n)
            test(n) = HMMS(n).logPdf(ds2);
        end
    results(m) = find(test == max(test));
end

percentCorrect =  sum(results == devLabels)/length(label);
