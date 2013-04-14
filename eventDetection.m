function eventDetection(inputFile, outputFile )
%EVENTDETECTION takes inputFile as input and attempts
%   to detect event within the input .wav file. Detected
%   events are written to the path of outputFile

devScriptPath = inputFile;
main;
writeOutput(outputFile);

end

