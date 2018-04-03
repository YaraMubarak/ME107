% - folderPath is a cell array that contains strings of the folders that
% will be searched.
% - configurations is a struct array of the data extracted from all the
% xlsx files.
% 
% FIELDS of a configuration struct:
%
% - m (mass, in grams)
% - r (radius of gyration, in mm)
% - h (height, in cm)
% - x (x positions, in cm)
% - y (y positions, in cm)
% - t (time, in s)
% - run (run number)
% 
% NOTES: 
%   - Each string in folderPath MUST END IN A BACKSLASH OR FORWARD SLASH.
%   - This function must be run in the same folder as the getXY function.
%   - All data must be in .xlsx files.
%   - This function assumes that the file names comply with the following
%     regex:
%     '(\d+_\d+)_rg_(\d+_\d+)_mass_(\d+)_height_run(\d).xlsx'

function configurations=getConfigurationData(folderPath)

regular_expression=...
'(\d+_\d+)_rg_(\d+_\d+)_mass_(\d+)_height_run(\d).xlsx';

count=1;
for m=1:length(folderPath)
    matchingFiles=dir([folderPath{m} '*.xlsx']);
    
    for n=1:length(matchingFiles)
        tokens=regexp(matchingFiles(n).name,regular_expression,'tokens');
        str_data=strrep(tokens{1},'_','.');
        
        current_configuration.r=str2num(str_data{1});
        current_configuration.m=str2num(str_data{2});
        current_configuration.h=str2num(str_data{3});
        current_configuration.run=str2num(str_data{4});
       
        [current_configuration.x, current_configuration.y, ...
            current_configuration.t]=...
            getXY([folderPath{m} matchingFiles(n).name]);
        
        configurations(count)=current_configuration;
        count=count+1;
    end
end

end