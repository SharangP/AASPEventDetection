function [eventRoll] = convertEventListToEventRoll(onset,offset,classNames)


% Initialize
eventRoll = zeros(ceil(offset(length(offset))*100),16);
eventID = {'alert','clearthroat','cough','doorslam','drawer','keyboard','keys',...
    'knock','laughter','mouse','pageturn','pendrop','phone','printer','speech','switch'};


% Fill-in eventRoll
for i=1:length(onset)
    
    pos = strmatch(classNames{i}, eventID);
    
    eventRoll(floor(onset(i)*100):ceil(offset(i)*100),pos) = 1;
    
end;
