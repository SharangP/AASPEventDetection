function [ LabelExpanded ] = labelExpand( LabelEvents, FeatureCell )
%labelExpand Transforms a vector of labels corresponding to events to a
%vector of labels corresponding to timeslices within events
%   Detailed explanation goes here

% organize labels for each time slice of each event into a vector
LabelExpanded = cellfun(@(x) ones(size(x,1),1), FeatureCell, 'UniformOutput', false);

for n = 1:length(FeatureCell)
    LabelExpanded{n} = LabelExpanded{n}*LabelEvents(n);
end

LabelExpanded = cell2mat(LabelExpanded);


end

