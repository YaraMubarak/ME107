%% Usage of the getConfigurationData function.
% This is a sample script demonstrating usage of the getConfigurationData
% function.
fileFolders={'Data/2x2x2_test_matrix/'};
configurations=getConfigurationData(fileFolders);
% NOTE: getConfigurationData may take a long time to run.
save configurations;