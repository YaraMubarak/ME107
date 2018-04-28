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
%% Processing data 04/05.
clear all;
load configurations_04_12;
trim=false;
trimmedConfigurations_04_05 = trimRuns(configurations_04_05,trim);
combinedConfigurations_04_05 = combineRuns(trimmedConfigurations_04_05);
averagedConfigurations_04_05 = averageRuns(combinedConfigurations_04_05);
save configurations_04_05_untrimmed;
%% Computing Velocity and Acceleration 04/05
clear all;
load configurations_04_05_trimmed;
configurations_04_05_trimmed_v_and_a=computeVelocityAndAcceleration(averagedConfigurations_04_05);
save configurations_04_05_trimmed_v_and_a;
%% Loading data 04/12.
folder='/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Data/';
fileFolders={[folder '2x2x2_test_matrix/'],[folder '04-05-18/'],[folder '04-12-18/']};
configurations_04_12 = getConfigurationData(fileFolders);
save configurations_04_12;
%% Processing data 04/12 (trimmed)
clear all;
load configurations_04_12;
trim=true;
trimmedConfigurations_04_12 = trimRuns(configurations_04_12,trim);
combinedConfigurations_04_12 = combineRuns(trimmedConfigurations_04_12);
averagedConfigurations_04_12 = averageRuns(combinedConfigurations_04_12);
save configurations_04_12_trimmed;
%% Processing data 04/12 (untrimmed)
clear all;
load configurations_04_12_untrimmed;
configurations_04_12_untrimmed_v_and_a=computeVelocityAndAcceleration(averagedConfigurations_04_12);
save configurations_04_12_untrimmed_v_and_a;
%% Computing Velocity and Acceleration 04/12
trimmedConfigurations_04_12 = trimRuns(configurations_04_12,trim);
combinedConfigurations_04_12 = combineRuns(trimmedConfigurations_04_12);
averagedConfigurations_04_12 = averageRuns(combinedConfigurations_04_12);
save('configurations_04_12_untrimmed','averagedConfigurations_04_12');
disp('It is Finished');cs
%% Get Model Test Data
clear all;
model_folder='/Users/UmColin/Documents/SHARED/6Sp18/6ME107/Roll Car/Github/ME107/RollCarCode/Data/ModelTest/';
model_configuration=getConfigurationData({model_folder});
model_trimmed=trimRuns(model_configuration,true);
model_combined=combineRuns(model_trimmed);
model_averaged=averageRuns(model_combined);
model_trimmed_v_and_a=computeVelocityAndAcceleration(model_averaged);
save model_trimmed_v_and_a;