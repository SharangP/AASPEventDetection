function weightOut = weightedMode( classes , previousClass)
%WEIGHTEDMODE determines the mode of the classes, weighted by
%   their probability of being confused.

weight = [1,1,1,1,1,1,.5,1,.5,1,1,1,.5,1,1,1];
scores = zeros(16,1);

if previousClass > 0
    weight(previousClass) = weight(previousClass)/3;
end

for ii = 1:length(classes)
    scores(classes(ii)) = scores(classes(ii)) + weight(classes(ii));
end

weightOut = find(scores == max(scores),1);

end

