% Christian Sherland
% 2-19-13
% ECE411 - Speech Processing Project 1 
%
%   Utility script to analyze output of
%   classifier with known annotations
%
%   Bugs:
%       None
%

%Run script to generate the classifications
%Comment this out if it has already been run for speed
%readTrainingData;

%Output is written to this file
fid = fopen('classifyOutputAnalysis.txt','w+');
fprintf(fid,'Actual \t\tClassified \t\tCorrect\n\n');

numCorrect = zeros(17,1);
numOccur = zeros(17,1);

%Displays prediction versus actual to show perect correct
for ii = 1:numel(classes.getX)
    actualClass = getClassName(label(ii));
    classifiedAs = getClassName(classes.getX(ii));
    isCorrect = strcmp(actualClass,classifiedAs);

    numCorrect(label(ii)) = numCorrect(label(ii)) + isCorrect;
    numOccur(label(ii)) = numOccur(label(ii)) + 1;
    
    fprintf(fid,'%s \t\t%s \t\t%d\n',actualClass,classifiedAs,isCorrect);
end

subplot(2,1,1)
bar(numCorrect)
title('Events Predicted By Classifier');
set(gca,'YLim',[0 5])
set(gca,'XTickLabel',{'alert','clearthroat','cough','doorslam','doorknock','drawer','keyboard','keys','knock','laughter','mouse','pageturn','pendrop','phone','printer','speech','switch'})

subplot(2,1,2)
bar(numOccur)
title('Events that Actually Occurred');
set(gca,'YLim',[0 5])
set(gca,'XTickLabel',{'alert','clearthroat','cough','doorslam','doorknock','drawer','keyboard','keys','knock','laughter','mouse','pageturn','pendrop','phone','printer','speech','switch'})

fclose(fid);
