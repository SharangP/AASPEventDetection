function loud = loudness(signal,winLength)
%LOUDNESS takes a signal as an inputans
%   and returns the RMS loudness of
%   the signal in DBs.
%
%   Christian Sherland
%   Sharang Phadke
%   Sameer Chauhan
%   3-14-13
%   The Cooper Union For the Advancement of Sicence and Art

loud = 20*log10(rms(buffer(signal,winLength)));
loud = loud(1:floor(length(signal)/winLength));

end

