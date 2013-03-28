function [ consolidatedClasses ] = consolidateClasses( classes, featureCell )
%consolidateClasses Summary of this function goes here
%   Detailed explanation goes here

ind = 1;
classesExpand = classes.getObservations;
newClasses = zeros(length(classesExpand),1);
for m = 1:length(featureCell)
    eventStart = ind;
    eventEnd = ind+length(featureCell{m});
    newClasses(eventStart:eventEnd) = mode(classesExpand(eventStart:eventEnd));
    ind = ind + 1;
end
consolidatedClasses = classes.setObservations(newClasses);

end

