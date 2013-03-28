function [results] = eventDetectionMetrics_frameBased(outputFile,GTFile)

% Frame-based evaluation for event detection task
% outputFile: the output of the event detection system
% GTFile: the ground truth list of events

% Load event list from output and ground-truth
[onset,offset,classNames] = loadEventsList(outputFile);
[onsetGT,offsetGT,classNamesGT] = loadEventsList(GTFile);


% Convert event list into frame-based representation (10msec resolution)
[eventRoll] = convertEventListToEventRoll(onset,offset,classNames);
[eventRollGT] = convertEventListToEventRoll(onsetGT,offsetGT,classNamesGT);


% Fix durations of eventRolls
if (size(eventRollGT,1) > size(eventRoll,1)) eventRoll = [eventRoll; zeros(size(eventRollGT,1)-size(eventRoll,1),16)]; end;
if (size(eventRoll,1) > size(eventRollGT,1)) eventRollGT = [eventRollGT; zeros(size(eventRoll,1)-size(eventRollGT,1),16)]; end;


% Compute frame-based metrics
Nref = sum(sum(eventRollGT));
Ntot = sum(sum(eventRoll));
Ntp = sum(sum(eventRoll+eventRollGT > 1));
Nfp = sum(sum(eventRoll-eventRollGT > 0));
Nfn = sum(sum(eventRollGT-eventRoll > 0));
Nsubs = min(Nfp,Nfn);


results.Rec = Ntp/(Nref+eps);
results.Pre = Ntp/(Ntot+eps);
results.F = 2*((results.Pre*results.Rec)/(results.Pre+results.Rec+eps));
results.AEER = (Nfn+Nfp+Nsubs)/(Nref+eps);
