% hmm test on one event
clear;
clc;

load training.mat
ceps = trainingCeps;
label = trainingLabel;
%% hmm things
prtPath( 'alpha', 'beta' );     % for prtDataSetTimeSeries

numStates = 3; % for each event, # of states
% 4 additional features + 5 MFCC
numFeatures = 5;                % ex. lowest 11 mfccs   

G1 = repmat(prtRvMvn('sigma',eye(numFeatures),'covarianceStructure','diagonal'),numStates,1);

learnHmm1 = prtRvHmm('components',G1);

HMMS = repmat(learnHmm1,20,1);

%% Train HMMs
disp('start training')

event = 1;

eventSetStart = [1; find(diff(label))];
eventSetEnd = [find(diff(label)); length(label)];

features = cellfun(@(x) x(:,1:numFeatures), ceps(eventSetStart(event):eventSetEnd(event)), 'UniformOutput', false);

for n = 1:length(HMMS)
    disp(n)
    
    ds = prtDataSetTimeSeries(features(n));
    HMMS(n) = HMMS(n).mle(ds);
end
