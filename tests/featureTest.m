featureTestMat = zeros(size(devFeatures{1},2),2);

for n = 1:size(devFeatures{1},2)
    retainedFeatures = n
    main
    c = [segPercentCorr devPercentCorr]
    featureTestMat(n,:) = c;
end