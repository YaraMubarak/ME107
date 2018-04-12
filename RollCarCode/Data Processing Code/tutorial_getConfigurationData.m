%% Usage of the getConfigurationData function.  Loading Data.
% This is a sample script demonstrating usage of the getConfigurationData
% function.
folder='C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository\RollCarCode\Data\2x2x2_test_matrix\';
folder='/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Data/';
fileFolders={[folder '2x2x2_test_matrix/']};%,[folder '04-05-18/']};
configurations_03_22 = getConfigurationData(fileFolders);
save configurations_03_22;
% NOTE: getConfigurationData may take a long time to run.
%% Processing data.
clear all;
load configurations_03_22;
trim=false;
trimmedConfigurations_03_22 = trimRuns(configurations_03_22,trim);
combinedConfigurations_03_22 = combineRuns(trimmedConfigurations_03_22);
averagedConfigurations_03_22 = averageRuns(combinedConfigurations_03_22);
save configurations_03_22_untrimmed;