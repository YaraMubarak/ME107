%% Usage of the getConfigurationData function.  Loading Data.
% This is a sample script demonstrating usage of the getConfigurationData
% function.
clear all;
folder='C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository\RollCarCode\Data\';
%folder='/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Data/';
fileFolders={[folder,'2x2x2_test_matrix',filesep],[folder,'04-05-18',filesep],[folder,'04-12-18',filesep]};
configurations_04_12 = getConfigurationData(fileFolders);
save configurations_04_12;
% NOTE: getConfigurationData may take a long time to run.
%% Processing data.
clear all;
load configurations_04_12;
trim=false;
trimmedConfigurations_04_12 = trimRuns(configurations_04_12,trim);
combinedConfigurations_04_12 = combineRuns(trimmedConfigurations_04_12);
averagedConfigurations_04_12 = averageRuns(combinedConfigurations_04_12);
save('configurations_04_12_untrimmed','averagedConfigurations_04_12');
disp('It is Finished')