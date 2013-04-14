% Event Analysis script
% take a look at features of each event to decide on hmm states, etc.

clear all;
close all;
load training.mat
%%

I = (1:20:length(trainingFeatures))+1;
L = getClassName(trainingLabels(I));

f1 = 3; f2 = 4; f3 = 5;

for n = 1:length(I)
    figure(f1)
    subplot(4,4,n); hold on
    
    centroid = trainingFeatures{n}(:,14);
    ste = trainingFeatures{n}(:,15);
    loud = trainingFeatures{n}(:,16);
    flux = trainingFeatures{n}(:,17);
    entropy = trainingFeatures{n}(:,18);
    rolloff = trainingFeatures{n}(:,19);
    
    plot(centroid./max(centroid),'c');
    plot(ste./max(ste),'m');
    plot(loud./max(loud),'b');
    plot(flux./max(flux),'r');
    plot(entropy./max(entropy),'g');
    plot(rolloff./max(rolloff),'k');
    title(L(n))
    
    figure(f2)
    subplot(4,4,n);
    plot(flux)
    title(L(n))
    
    figure(f3)
    subplot(4,4,n);
    plot(ste)
    title(L(n))
    
    
end

% notes:
% Centroid and STE match up well -> dont need both
% STE is different from rest of features -> provides new info
% loudness seems to have little info
% flux and rolloff good
% idea: create 3 hmms -> 

%% Look at characteristics of features of each event
% train GMMs

I = 1:20:length(trainingFeatures);
F = cell(length(I),1);
rv = prtRvGmm('nComponents',2);
RV = repmat(rv,16,18);
% RV = zeros(20,size(trainingFeatures{1},2));

for n = 1:length(I)
    n
    F{n} = cell2mat(trainingFeatures(I(n):I(n)+19));
    for m = [1:5 14:size(RV,2)]
        ds = prtDataSetClass(F{n}(:,m));
        RV(n,m) = mle(rv,ds);
    end
end

%% run GMM like below on training features to get sequences, train neural net


%%
retained = [1:5 14:size(RV,2)];
% res = cell2mat(devFeatures);
res = cell(max(retained),1);
devFeatures2 = cell2mat(devFeatures);

% check logPdf against each GMM for each respective feature
for n = retained
    for m = 1:16
        res{n}(:,m) = RV(m,n).logPdf(devFeatures2(:,m));
    end
end

% choose most votes
J = zeros(length(res{1}),length(res));
for n = retained
    [~, J(:,n)] = max(res{n},[],2);
end

%% mmm make a neural net and classify based on the logPdfs of each class
