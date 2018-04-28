clear all; close all; clc;
ComputerOwner = 'Patrick';
ProjectFolder = 'RollCarCode';
DataFolder = strcat('Data',filesep,'2x2x2_test_matrix');
DataCodeFolder = 'Data Processing Code';
SaveFolder = 'Saved Labels';
switch ComputerOwner
    case 'Patrick'
        GitRepositoryPath = 'C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository';
    case 'Colin'
        GitRepositoryPath = '/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107';
    case 'Jay'
        GitRepositoryPath = 'C:\Users\Jay\Documents\ME107';
    otherwise
        error('ME107RollCarPhysicsModel: ComputerOwner name %s not found in Possible options.Please add your options to the list',ComputerOwner) 
end

DataCodeFullPath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,DataCodeFolder);
DataFullPath = strcat(GitRepositoryPath,filesep,ProjectFolder,filesep,DataFolder);

addpath(DataFullPath,DataCodeFullPath)
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