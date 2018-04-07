% FIELDS of a trimmedConfiguration struct:
%
% - m (mass, in grams)
% - r (radius of gyration, in mm)
% - h (height, in cm)
% - x (x positions, in cm)
% - y (y positions, in cm)
% - t (time, in s)
% - run (run number)
% - passes (number of complete passes)
%
% This function trims the part of the data after which the rollcar fails to
% pass over the center hill.

function trimmedConfigurations=trimRuns(configurations,trim)
    begin_left_hillx=213.9+129.7+180.7+108.8;
    end_right_hillx=108.8;
    
    for m=1:length(configurations)
    
    xData=configurations(m).x;
    
    made_it_over_hill=true;
    increasing=true;
    index=2;
    passes=0;
    
    while made_it_over_hill && index<=length(xData)
        localXMax=68.1+213.9+129.7+180.7+108.8;
        
        if xData(index)<xData(index-1) && increasing
            increasing=false;
            localXMax=xData(index-1);
            if localXMax<begin_left_hillx
                made_it_over_hill=false;
            else
                passes=passes+1;
            end
        elseif xData(index)>xData(index-1) && ~increasing
            increasing=true;
        end
        index=index+1;
    end
    
    trimmedConfigurations(m).m=configurations(m).m;
    trimmedConfigurations(m).r=configurations(m).r;
    trimmedConfigurations(m).h=configurations(m).h;
    
    if trim
    
    trimmedConfigurations(m).x=xData(1:index-2);
    trimmedConfigurations(m).y=configurations(m).y(1:index-2);
    trimmedConfigurations(m).t=configurations(m).t(1:index-2);
    
    else
        
    trimmedConfigurations(m).x=xData;
    trimmedConfigurations(m).y=configurations(m).y;
    trimmedConfigurations(m).t=configurations(m).t;
        
    end
    
    trimmedConfigurations(m).run=configurations(m).run;
    trimmedConfigurations(m).passes=passes;
    
    end
end