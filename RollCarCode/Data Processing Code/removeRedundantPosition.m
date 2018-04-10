function config2=removeRedundantPosition(config1)
    config2.m=config1.m;
    config2.r=config1.r;
    config2.h=config1.h;
    
    config2.passes=config1.passes;
    config2.total_runs=config1.total_runs;
    
    uniqueX=cell(size(config1.x));
    uniqueY=cell(size(config1.y));
    timeAverage=cell(size(config1.t));
    
    for n=1:length(config1.passes)
            rawX=config1.x{n};
            rawY=config1.y{n};
            rawT=config1.t{n};
                
            uniqueX{n}=rawX(1);
            uniqueY{n}=rawY(1);
            timeAverage{n}=[];
                
            indices_with_current_position=1;
                
            for q=2:length(rawX)
                if rawX(q)~=rawX(q-1) || rawY(q)~=rawY(q-1)
                    uniqueX{n}=[uniqueX{n} rawX(q)];
                    uniqueY{n}=[uniqueY{n} rawY(q)];
                    timeAverage{n}=[timeAverage{n} ...
                    mean(rawT(indices_with_current_position))];
                        indices_with_current_position=q;
                else
                    indices_with_current_position=...
                       [indices_with_current_position q];
                end
            end
            
            timeAverage{n}=[timeAverage{n} mean(rawT(indices_with_current_position))];
    end
    
    config2.x=uniqueX;
    config2.y=uniqueY;
    config2.t=timeAverage;
    
    minSizePosArr=length(config2.x{1});
    for m=2:config2.total_runs
        if length(config2.x{m})<minSizePosArr
            minSizePosArr=length(config2.x{m});
        end
    end
    
    for m=1:config2.total_runs
        config2.x{m}=config2.x{m}(1:minSizePosArr);
        config2.y{m}=config2.y{m}(1:minSizePosArr);
        config2.t{m}=config2.t{m}(1:minSizePosArr);
    end
    
    
    config2.xerr=0.2*ones(size(config2.x{m}));
    config2.yerr=0.2*ones(size(config2.x{m}));
    config2.terr=zeros(size(config2.x{m}));
end