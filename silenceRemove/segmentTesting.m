clear all;

% THIS SCRIPT MAKES NO SENSE
% I HAVE NO IDEA WHAT I WAS DOING 
% IN THE PROCESS THE FUNCTION segTestFun CHANGED MULTIPLE TIMES
% NEVER MIND IT




winTime = 0.05;
stepTime = winTime;
weights = 1:0.01:5;
numEvents = zeros(length(weights));
segTime = cell(length(weights));
for ii = 1:length(weights)
    [segTime numEvents(ii) ] = segTestFun(weights(ii), winTime,stepTime);
end
figure(1)
plot(weights,numEvents)

%% Weights that results in right number of events:

goodWeights = weights(numEvents==36);

% times = cell(length(goodWeights));
% for ii = 1:length(goodWeights)
%     times{ii} = segTestFun(goodWeights(ii), winTime, stepTime);
% end

%% compare with stuff
%% minimize sum of mean square error. 
mseTotal = zeros(length(goodWeights),1);
mseOnOffset= zeros(length(goodWeights),2);
for ii = 1:length(goodWeights)
    mseOnOffset(ii,:) = sum( ((times{ii}- actualTimes).^2) ,1);
    mseTotal(ii) = sum(sum( ((times{ii}- actualTimes).^2) ,2));
end

figure(2)
subplot(311);
plot(goodWeights,mseTotal);
subplot(312);
plot(goodWeights,mseOnOffset(:,1));
subplot(313)
plot(goodWeights,mseOnOffset(:,2));

%% Weight must be integer value SO it is 3. 

%% Second Test with window and step sizes
winTime = 0.01:0.01:0.25;   
winTime(7) = 0.07;
winTime(17)= 0.17;
stepTime = winTime;
% stepTime =0.05;
weight = 3;
segTime = cell(length(winTime),1);
for ii = 1:length(winTime)
    segTime{ii} = segTestFun(weight, winTime(ii), winTime(ii));
end

goodTime = segTime{5};
mseOnOffsetWin= sum( ((goodTime- actualTimes).^2) ,1);
 mseTotalWin = sum(sum( ((goodTime- actualTimes).^2) ,2));


figure(2)
subplot(311);
plot(winTime(length(segTime)==36) ,mseTotal);
subplot(312);
plot(winTime(length(segTime)==36),mseOnOffset(:,1));
subplot(313)
plot(winTime(length(segTime)==36),mseOnOffset(:,2));

%% So the best window size is 0.05
%% best step time is 0.04
winTime = 0.05;
stepTime = 0.01:0.005:0.1;
weight = 3;
stepTimes = cell(length(stepTime),1);
numEvents = length(stepTime);
for ii = 1:length(stepTime)
    [stepTimes{ii} numEvents(ii)] = segTestFun(weight,winTime,stepTime(ii));
end

goodIndex = find((numEvents == 36));

mseOnOffsetStep = zeros(length(goodIndex),2);
mseTotalStep = zeros(length(goodIndex),1);
for ii = 1:length(goodIndex)
    mseOnOffsetStep(ii,:) = sum( ((stepTimes{goodIndex(ii)}- actualTimes).^2) ,1);
    mseTotalStep(ii) = sum(mseOnOffsetStep(ii,:));
end

