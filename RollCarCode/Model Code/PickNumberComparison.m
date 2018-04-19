%clear all; close all; clc;
load configurations_04_12_untrimmed;
for ConfigPick = 1:numel(averagedConfigurations_04_12)
    config = averagedConfigurations_04_12(ConfigPick);
    m = config.m/1000;
    rg = config.r/1000;
    rw = .11882; % from solid works model
    Passes = config.passes;
    TotalRuns = config.total_runs;
    DropHeight = config.h;
    fprintf('Pick: %i \t m: %.4f \t rg: %.5f \t h: %i \t Passes: %.2f \n',ConfigPick,m,rg,DropHeight,dot(TotalRuns,Passes)/sum(TotalRuns))
end