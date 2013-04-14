R = zeros(10,1);
FCs = linspace(31000,39000,10);

for m = 1:10
    fc = FCs(m)
    main
    R(m) = devPercentCorr
end