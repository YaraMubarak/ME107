%% Usage of the getConfigurationData function.
% This is a sample script demonstrating usage of the getConfigurationData
% function.
fileFolders={'C:\Users\pcarl\Documents\College Things\ME 107\Roll Car\Github Code Repository\RollCarCode\Data\2x2x2_test_matrix\'};
configurations_03_22 = getConfigurationData(fileFolders);
% NOTE: getConfigurationData may take a long time to run.
trimmedConfigurations_03_22 = trimRuns(configurations_03_22);
combinedConfigurations_03_22 = combineRuns(trimmedConfigurations_03_22);
averagedConfigurations_03_22 = averageRuns(combinedConfigurations_03_22);
%save averagedConfigurations_03_22;