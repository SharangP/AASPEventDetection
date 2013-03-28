function [ eventLabels ] = getEventLabels( sigTimes, Annots)
%getLabels generates a vector of labels corresponding to time windows as
%denoted by an annotations cell
%   Detailed explanation goes here

% assign labels by checking whether sigTimes overlap with annotation times
% start by taking differences between sigTimes and annotations
d11 = repmat(sigTimes(:,1),1,length(Annots{1})) - repmat(Annots{1}',length(sigTimes),1);
d12 = repmat(sigTimes(:,1),1,length(Annots{1})) - repmat(Annots{2}',length(sigTimes),1);
d21 = repmat(sigTimes(:,2),1,length(Annots{1})) - repmat(Annots{1}',length(sigTimes),1);
d22 = repmat(sigTimes(:,2),1,length(Annots{1})) - repmat(Annots{2}',length(sigTimes),1);

% segmented events falling outside annotation times
D1 = (d11 < 0) & (d21 < 0);
D2 = (d12 > 0) & (d22 > 0);
events = ((~D1) & (~D2));

eventLabels = zeros(length(sigTimes),1);

for m = 1:length(eventLabels)
    className = Annots{3}(find(events(m,:),1));
    if isempty(className)
        eventLabels(m) = 0;
    else
        eventLabels(m) = getClassNum(className);
    end
end

end

