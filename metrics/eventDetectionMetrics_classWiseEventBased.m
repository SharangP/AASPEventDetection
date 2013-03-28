function [results] = eventDetectionMetrics_classWiseEventBased(outputFile,GTFile)

% Class-wise event-based evaluation for event detection task
% outputFile: the output of the event detection system
% GTFile: the ground truth list of events

% Initialize
eventID = {'alert','clearthroat','cough','doorslam','drawer','keyboard','keys',...
    'knock','laughter','mouse','pageturn','pendrop','phone','printer','speech','switch'};


% Load event list from output and ground-truth
[onset,offset,classNames] = loadEventsList(outputFile);
[onsetGT,offsetGT,classNamesGT] = loadEventsList(GTFile);


% Total number of detected and reference events per class
Ntot = zeros(16,1);
for i=1:length(onset)
    pos = strmatch(classNames{i}, eventID);
    Ntot(pos) = Ntot(pos)+1;
end;

Nref = zeros(16,1);
for i=1:length(onsetGT)
    pos = strmatch(classNamesGT{i}, eventID);
    Nref(pos) = Nref(pos)+1;
end;
I = find(Nref>0); % index for classes present in ground-truth


% Number of correctly transcribed events per class, onset within a +/-100 ms range
Ncorr = zeros(16,1);
NcorrOff = zeros(16,1);
for j=1:length(onsetGT)
    for i=1:length(onset)
        
        if( strcmp(classNames{i},classNamesGT{j}) && (abs(onsetGT(j)-onset(i))<=0.1) )
            pos = strmatch(classNames{i}, eventID);
            Ncorr(pos) = Ncorr(pos)+1;
            
            % If offset within a +/-100 ms range or within 50% of ground-truth event's duration
            if abs(offsetGT(j) - offset(i)) <= max(0.1, 0.5 * (offsetGT(j) - onsetGT(j)))
                pos = strmatch(classNames{i}, eventID);
                NcorrOff(pos) = NcorrOff(pos) +1;
            end;
            
            break; % In order to not evaluate duplicates
            
        end;
    end;
end;


% Compute onset-only class-wise event-based metrics
Nfp = Ntot-Ncorr;
Nfn = Nref-Ncorr;
Nsubs = min(Nfp,Nfn);
tempRec = Ncorr(I)./(Nref(I)+eps);
tempPre = Ncorr(I)./(Ntot(I)+eps);
results.Rec = mean(tempRec);
results.Pre = mean(tempPre);
tempF =  2*((tempPre.*tempRec)./(tempPre+tempRec+eps));
results.F = mean(tempF);
tempAEER = (Nfn(I)+Nfp(I)+Nsubs(I))./(Nref(I)+eps);
results.AEER = mean(tempAEER);


% Compute onset-offset class-wise event-based metrics
NfpOff = Ntot-NcorrOff;
NfnOff = Nref-NcorrOff;
NsubsOff = min(NfpOff,NfnOff);
tempRecOff = NcorrOff(I)./(Nref(I)+eps);
tempPreOff = NcorrOff(I)./(Ntot(I)+eps);
results.RecOff = mean(tempRecOff);
results.PreOff = mean(tempPreOff);
tempFOff =  2*((tempPreOff.*tempRecOff)./(tempPreOff+tempRecOff+eps));
results.FOff = mean(tempFOff);
tempAEEROff = (NfnOff(I)+NfpOff(I)+NsubsOff(I))./(Nref(I)+eps);
results.AEEROff = mean(tempAEEROff);
