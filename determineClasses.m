function classes = determineClasses(frameClasses, frameTimes, frameLength)
%DETERMINECLASSES takes frame by frame classification and
%   determines the class of events segmented at times
%   specified in frameTimes

eventLengths = round((frameTimes(:,2) - frameTimes(:,1))/frameLength);
classes = cell(length(eventLengths));

prevEndInd = 1;

for ii = 1:length(eventLengths)
   currentEventClasses = frameClasses(prevEndInd:eventLengths(ii)+prevEndInd);
   guessClass = mode(currentEventClasses);
   classes{ii} = getClassName(guessClass);
   prevEndInd = eventLengths(ii);
end

end

