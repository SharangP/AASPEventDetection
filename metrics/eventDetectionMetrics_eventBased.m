function [results] = eventDetectionMetrics_eventBased(outputFile,GTFile)

% Event-based evaluation for event detection task
% outputFile: the output of the event detection system
% GTFile: the ground truth list of events

% Load event list from output and ground-truth
[onset,offset,classNames] = loadEventsList(outputFile);
[onsetGT,offsetGT,classNamesGT] = loadEventsList(GTFile);


% Total number of detected and reference events
Ntot = length(onset);
Nref = length(onsetGT);


% Number of correctly transcribed events, onset within a +/-100 ms range
Ncorr = 0;
NcorrOff = 0;
for j=1:length(onsetGT)
    for i=1:length(onset)
        
        if( strcmp(classNames{i},classNamesGT{j}) && (abs(onsetGT(j)-onset(i))<=0.1) )
            Ncorr = Ncorr+1; 
            
            % If offset within a +/-100 ms range or within 50% of ground-truth event's duration
            if abs(offsetGT(j) - offset(i)) <= max(0.1, 0.5 * (offsetGT(j) - onsetGT(j)))
                NcorrOff = NcorrOff +1;
            end;
            
            break; % In order to not evaluate duplicates
            
        end;
    end;
    
end;


% Compute onset-only event-based metrics
Nfp = Ntot-Ncorr;
Nfn = Nref-Ncorr;
Nsubs = min(Nfp,Nfn);
results.Rec = Ncorr/(Nref+eps);
results.Pre = Ncorr/(Ntot+eps);
results.F = 2*((results.Pre*results.Rec)/(results.Pre+results.Rec+eps));
results.AEER= (Nfn+Nfp+Nsubs)/(Nref+eps);


% Compute onset-offset event-based metrics
NfpOff = Ntot-NcorrOff;
NfnOff = Nref-NcorrOff;
NsubsOff = min(NfpOff,NfnOff);
results.RecOff = NcorrOff/(Nref+eps);
results.PreOff = NcorrOff/(Ntot+eps);
results.FOff = 2*((results.PreOff*results.RecOff)/(results.PreOff+results.RecOff+eps));
results.AEEROff= (NfnOff+NfpOff+NsubsOff)/(Nref+eps);
