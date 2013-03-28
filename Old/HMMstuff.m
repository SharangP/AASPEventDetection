% Playing with HMMs
% 2/26/2013
% Sharang Phadke

% segment -> [0 0 0 0 1 1 1 1 1 0 0 0 0 1 1....]
% 1 = event
% 0 = no event
% pass each group of 1's (each event) through the HMM to classify

% each event has a bunch of states in time

% evaluate likelyhood of each event coming from each hmm. choose event with
% max likelyhood

numStates = 3; % for each event, determine a # of statest
numFeatures = 2; %ex. mfccs

prtPath( 'alpha', 'beta' ); %for prtDataSetTimeSeries
A = [.9 .1 0; 0 .9 .1; .1 0 .9];
gaussians = repmat(prtRvMvn('sigma',eye(numFeatures)),numStates,1);
%     dont need to set means:
gaussians(1).mu = [-2 -2];
gaussians(2).mu = [2 -2];
gaussians(3).mu = [2 2];

sourceHmm = prtRvHmm('pi',[1 1 1]/3,... % equiprobable starting
  'transitionMatrix',A,...
  'components',gaussians);
%   drawing data from hmm (dont actually do this)
y = sourceHmm.draw([100 100 100 100 100 100]);
dstest = prtDataSetTimeSeries(y);

gaussiansLearn = repmat(prtRvMvn,3,1);
learnHmm = prtRvHmm('components',gaussiansLearn);
learnHmm = learnHmm.mle(dstest);
%   likelyhood that each of the 6 drawn data sets are from this model
learnHmm.logPdf(dstest)
