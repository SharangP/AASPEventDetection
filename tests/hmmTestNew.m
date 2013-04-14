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
init
globalVar
load training.mat
load development.mat

%% hmm things
numStates = 3;
numFeatures = 5; 

G1 = repmat(prtRvMvn('sigma',eye(numFeatures),'covarianceStructure','diagonal'),numStates,1);
learnHmm1 = prtRvHmm('components',G1);
HMMS = repmat(learnHmm1,16,1);

%% Train HMMs
disp('start training')

% eventSetStart = [1; find(diff(trainingLabels))];
% eventSetEnd = [find(diff(trainingLabels)); length(trainingLabels)];


for n = 1:20:length(trainingLabels)
    ds = prtDataSetTimeSeries(trainingFeatures(n:n+19));
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

percentCorrect =  sum(results == devLabels)/length(trainingLabels);
