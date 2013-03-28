function [onset,offset,classNames] = loadEventsList(filename)

% Open raw file
fid = fopen(filename,'r+');

% Read 1st line
tline = fgetl(fid);
onset_offset(:,1) = sscanf(tline, '%f\t%f\t%*s');
classNames{1} = char(sscanf(tline, '%*f\t%*f\t%s')');

% Read rest of the lines
i=1;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    if (ischar(tline))
        onset_offset(:,i) = sscanf(tline, '%f\t%f\t%*s');
        classNames{i} = char(sscanf(tline, '%*f\t%*f\t%s')');
    end;
end

% Split onset_offset
onset = onset_offset(1,:)';
offset = onset_offset(2,:)';

% Close file
fclose(fid);