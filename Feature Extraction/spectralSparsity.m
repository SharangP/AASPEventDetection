function specSparcity = spectralSparsity(signal,winLength, fs)
%SPECTRALSPARSITY takes a signal, window length
%   and sampling frequency as input and returns
%   a vector containing the spectral sparsity.
%
%   Christian Sherland
%   Sharang Phadke
%   Sameer Chauhan
%   3-14-13
%   The Cooper Union For the Advancement of Sicence and Art

spec = spectrogram(signal,triang(winLength),0,1024,fs);
spec = spec./(repmat(sum(spec),size(spec,1),1));
specSparcity = max(spec); 

end