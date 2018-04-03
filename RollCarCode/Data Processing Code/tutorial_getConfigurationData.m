%% Usage of the getConfigurationData function.
% This is a sample script demonstrating usage of the getConfigurationData
% function.
fileFolders={'/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Data/2x2x2_test_matrix/'};
configurations_03_22=getConfigurationData(fileFolders);
% NOTE: getConfigurationData may take a long time to run.
trimmedConfigurations_03_22=trimRuns(configurations_03_22);
combinedConfigurations_03_22=combineRuns(trimmedConfigurations_03_22);
save combinedConfigurations_03_22;