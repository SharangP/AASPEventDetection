function [className] = getClassName(classNum)
% Christian Sherland
% 2-19-13
% Speech Processing Project 1
%
% getClassName.m
%
%   Given a class number input, returns the name 
%   of the class
%

    className = cell(length(classNum),1);

    classNames = {'alert','clearthroat','cough','doorslam','knock','drawer','keyboard','keys','laughter','mouse','pageturn','pendrop','phone','printer','speech','switch'}';
    if length(classNum) > 1
        className(classNum ~= 0) = classNames(classNum(classNum ~= 0));
        className(classNum == 0) = {'unknown'};
    else
        if classNum ~= 0
            className = classNames{classNum};
        else
            className = 'unknown';
        end
    end
 
end

