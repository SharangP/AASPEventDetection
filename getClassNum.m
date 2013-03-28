function [classNum] = getClassNum(className)
% Christian Sherland
% 2-19-13
% Speech Processing Project 1
%
% getClassName.m
%
%   Given a class name input, returns the n
%   number of the class
%

    if(strcmp(className,'doorknock'))
        className = 'knock';
    end

    classNames = {'alert','clearthroat','cough','doorslam','knock','drawer','keyboard','keys','laughter','mouse','pageturn','pendrop','phone','printer','speech','switch'}';
    classNum = find(strcmp(className,classNames));
    
end

