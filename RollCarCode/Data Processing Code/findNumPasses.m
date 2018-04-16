function pass=findNumPasses(configs,h,m,r)
    ind=find([configs.m]==m & [configs.r]==r & [configs.h]==h);
    pass=configs(ind).passes;
end