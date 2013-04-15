function [ newClasses ] = classesToCell( classes, featureCell )
%classesToCell Summary of this function goes here
%   Detailed explanation goes here

ind = 1;
newClasses = cell(size(featureCell,1),size(featureCell,2));
for m = 1:length(featureCell)
    newClasses{m} = zeros(1,17);
    eventStart = ind;
    eventEnd = ind+length(featureCell{m});
    [uniques, numUniques] = count_unique(classes(eventStart:eventEnd));
    newClasses{m}(uniques) = numUniques;
    ind = ind + 1;
end

end

