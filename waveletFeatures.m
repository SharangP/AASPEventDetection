function [ waveFeatures ] = waveletFeatures( signal, win)
%waveletFeatures produces a wavelet decomposition of a signal
%   waveFeatures = [mean std mean(diff) std(diff)]

FeatureLen = floor(length(signal)/win);
buf = buffer(signal,win)';
waveFeatures = zeros(FeatureLen,4);

for n = 1:FeatureLen
    [C, L] = wavedec(buf(n,:),3,'dmey');
    w = C(1:L(1));
    waveFeatures(n,:) = [mean(w) std(w) mean(diff(w)) std(diff(w))];
end

end

