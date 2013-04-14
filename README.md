AASPEventDetection
==================

IEEE AASP Event Detection Project

Authors:
    Sameer Chauhan
    Sharang Phadke
    Christian Sherland

In order to execute this event detection system, simply call the function
eventDetection(inputFile, outputFile) where inputFile is the path to the 
sound file in which events are being detected and outputFile is the path
to the .txt file to which the output should be written.

This submission is not paralellized or multithreaded. It utilizes only one
core. 

This submission uses an open sources toolbox called Pattern Recognition 
Toolbox (PRT) for classification. PRT has been included with this submission
and will be added to the MATLAB path when the eventDetection function is
called.