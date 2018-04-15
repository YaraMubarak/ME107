% FIELDS of a combinedConfiguration struct:
%
% - m (mass, in grams)
% - r (radius of gyration, in mm)
% - h (height, in cm)
% - x (x positions, cell array containing all runs, in cm)
% - xerr (95% error in x, cell array containing all runs, in cm)
% - y (y positions, cell array containing all runs, in cm)
% - yerr (95% error in y, cell array containing all runs, in cm)
% - t (time, cell array containing all runs, in s)
% - terr (95% error in t, cell array containing all runs, in s)
% - passes (number of complete passes - an array 
%           containing all passes for the runs)
% - total_runs (total runs conducted)
%
% This function combines data from runs 1,2,3,4, of a particular
% configuration.

function combinedConfigurations=combineRuns(trimmedConfigurations)
    index=1;
    
    combinedConfigurations(1).m=-1;
    combinedConfigurations(1).r=-1;
    combinedConfigurations(1).h=-1;
    
    for m=1:length(trimmedConfigurations)
        mass=trimmedConfigurations(m).m;
        r=trimmedConfigurations(m).r;
        h=trimmedConfigurations(m).h;
        
        if isempty(find([combinedConfigurations.m]==mass & ...
                [combinedConfigurations.r]==r & ...
                [combinedConfigurations.h]==h))
        
        repeats=find([trimmedConfigurations.m]==mass & ...
            [trimmedConfigurations.r]==r & ...
            [trimmedConfigurations.h]==h);
        
        all_passes=[trimmedConfigurations.passes];
        pass_array=all_passes(repeats);
        
        combinedConfigurations(index).m=mass;
        combinedConfigurations(index).r=r;
        combinedConfigurations(index).h=h;
        
        xData=cell(1,length(repeats));
        yData=cell(1,length(repeats));
        xErr=cell(1,length(repeats));
        yErr=cell(1,length(repeats));
        tData=cell(1,length(repeats));
        
        for n=1:length(repeats)
            xData{n}=trimmedConfigurations(repeats(n)).x;
            yData{n}=trimmedConfigurations(repeats(n)).y;
            xErr{n}=0.2*ones(size(trimmedConfigurations(repeats(n)).x));
            yErr{n}=0.2*ones(size(trimmedConfigurations(repeats(n)).x));
            tData{n}=trimmedConfigurations(repeats(n)).t;
            tErr{n}=zeros(size(trimmedConfigurations(repeats(n)).x));
        end
        
        combinedConfigurations(index).x=xData;
        combinedConfigurations(index).xerr=xErr; % Error in ruler
        combinedConfigurations(index).y=yData;
        combinedConfigurations(index).yerr=yErr; % Error in ruler
        combinedConfigurations(index).t=tData;
        combinedConfigurations(index).terr=tErr; 
        combinedConfigurations(index).passes=pass_array;
        combinedConfigurations(index).total_runs=length(repeats);
        
        index=index+1;
        
        end
    end
end