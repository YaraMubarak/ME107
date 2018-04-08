% Combines all runs in combinedConfiguration struct and gives terr.
% Note: terr=NAN if only one run exists for each pass.

function averagedConfigurations=averageRuns(combinedConfigurations)

for m=1:length(combinedConfigurations)
averagedConfigurations(m)=removeRedundantPosition(combinedConfigurations(m));
end

for m=1:length(combinedConfigurations)
    
    averagedConfigurations(m).t={};
    averagedConfigurations(m).terr={};
    averagedConfigurations(m).passes=[];
    
    current_config=removeRedundantPosition(combinedConfigurations(m));
        
    uniquePasses=unique(current_config.passes);
    
    xDataCopy=averagedConfigurations(m).x;
    yDataCopy=averagedConfigurations(m).y;
    averagedConfigurations(m).x=cell(1,length(uniquePasses));
    averagedConfigurations(m).y=cell(1,length(uniquePasses));
    
    for n=1:length(uniquePasses)
        indices=find(current_config.passes==uniquePasses(n));
        timeAverages=[];
        
        for p=1:length(indices)
            timeAverages=[timeAverages; current_config.t{p}];
        end
        
        error=tinv(0.975,length(indices)-1)/...
            sqrt(length(indices)-1)*std(timeAverages,1);
        
        averagedConfigurations(m).x{n}=xDataCopy{indices(1)};
        averagedConfigurations(m).y{n}=yDataCopy{indices(1)};

        averagedConfigurations(m).t{n}=mean(timeAverages,1);
        averagedConfigurations(m).terr{n}=error;
        averagedConfigurations(m).passes=[averagedConfigurations(m).passes ...
            uniquePasses(n)];
        averagedConfigurations(m).total_runs(n)=length(indices);
    end
    
end
disp('');
end