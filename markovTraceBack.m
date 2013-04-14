function [ states ] = markovTraceBack( seq, badConfMat, occurances )
%markovTraceBack Uses MATLAB's statistics hmm model to compute viterbi on
%the most probable state sequence given a received sequence seq.
%   Detailed explanation goes here

numStates = 17;
zeroToEvent = .75;      %prob of trans from 0 to an event
stayInEvent = .65;   %prob of staying in an event

% contrive a transition matrix
T = .01*ones(numStates);
T = T + (stayInEvent-.01*numStates)*eye(numStates);
T(:,1) = 0;
eventToZero = 1-sum(T(2,:));
T(:,1) = [1-zeroToEvent eventToZero*ones(1,numStates-1)]';
T(1,:) = [1-zeroToEvent zeroToEvent*ones(1,numStates-1)/(numStates-1)];

% contrive an emission matrix from a bad confusion matrix
keyboard
E = zeros(numStates);
E(1,:) = zeroToEvent/numStates;
E(1) = 1-zeroToEvent;
for n = 1:length(occurances)
    E(n+1,2:end) = badConfMat(n,:)/occurances(n);
end

% E = eye(numStates);

% run hmmviterbi on the seq with the contrived parameters
states = hmmviterbi(seq,T,E)';

end

