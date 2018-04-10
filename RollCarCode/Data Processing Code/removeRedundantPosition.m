function config2=removeRedundantPosition(config1)
    config2.m=config1.m;
    config2.r=config1.r;
    config2.h=config1.h;
    
    config2.passes=config1.passes;
    config2.total_runs=config1.total_runs;
    
    uniqueX=cell(size(config1.x));
    uniqueY=cell(size(config1.y));
    timeAverage=cell(size(config1.t));
    
    uniquePasses=unique(config1.passes);
    minSizePosArr=zeros(1,length(uniquePasses));
    
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
    
    for n=1:length(uniquePasses)
        ind=find(config2.passes==uniquePasses(n));
        minSizePosArr(n)=length(config2.x{ind(1)});
        for p=2:length(ind)
            if length(config2.x{ind(p)})<minSizePosArr(n)
                minSizePosArr(n)=length(config2.x{ind(p)});
            end
        end
    end
    
    for m=1:config2.total_runs
        index=-1;
        for p=1:length(uniquePasses)
            if uniquePasses(p)==config2.passes(m)
                index=p;
            end
        end
        disp('');
        config2.x{m}=config2.x{m}(1:minSizePosArr(index));
        config2.y{m}=config2.y{m}(1:minSizePosArr(index));
        config2.t{m}=config2.t{m}(1:minSizePosArr(index));
        config2.xerr{m}=0.2*ones(size(config2.x{m}));
        config2.yerr{m}=0.2*ones(size(config2.x{m}));
        config2.terr{m}=zeros(size(config2.x{m}));
    end
    
    
end