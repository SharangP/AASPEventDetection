function [ consolidatedClasses ] = consolidateClasses( classes, featureCell )
%consolidateClasses Summary of this function goes here
%   Detailed explanation goes here

ind = 1;
classesExpand = classes.getX;
newClasses = zeros(length(featureCell),1);
for m = 1:length(featureCell)
    eventStart = ind;
    eventEnd = ind+length(featureCell{m});
    newClasses(m) = mode(classesExpand(eventStart:eventEnd));
    ind = ind + 1;
end

consolidatedClasses = getClassName(newClasses);

end

