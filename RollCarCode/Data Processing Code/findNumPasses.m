function pass=findNumPasses(configs,h,m,r)
% This function extracts the array of the passes completed from a
% particular configuration, given the configuration array, and the height,
% mass, and radius of the desired configuration.
    ind=find([configs.m]==m & [configs.r]==r & [configs.h]==h);
    pass=configs(ind).passes;
end