function writeOutput( outputFile , segTimes, classes)
%WRITEOUTPUT writes analysis of event data 
%   to the file name specified by outputFile

fid = fopen(outputFile,'w');

for ii = 1:length(segTimes)
    fprintf(fid,'%.2f\t%.2f\t%s\n',segTimes(ii,1) ,segTimes(ii,2), classes{ii});
end

fclose(fid);
end

