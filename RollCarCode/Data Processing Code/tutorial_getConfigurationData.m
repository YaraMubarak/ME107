%% Usage of the getConfigurationData function.  Loading Data.
% This is a sample script demonstrating usage of the getConfigurationData
% function.
folder='C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository\RollCarCode\Data\2x2x2_test_matrix\';
folder='/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Data/';
fileFolders={[folder '2x2x2_test_matrix/'],[folder '04-05-18/']};
configurations_04_05 = getConfigurationData(fileFolders);
% NOTE: getConfigurationData may take a long time to run.
%% Processing data.
clear all;
load configurations_04_05;
trim=true;
trimmedConfigurations_04_05 = trimRuns(configurations_04_05,trim);
combinedConfigurations_04_05 = combineRuns(trimmedConfigurations_04_05);
averagedConfigurations_04_05 = averageRuns(combinedConfigurations_04_05);
save configurations_04_05_trimmed;