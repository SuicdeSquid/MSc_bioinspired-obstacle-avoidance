clc;
clear all;
close all;

% Get user input parameters
% [fileName, Tau, Ag, Number] = getUserInputs_EMD();
[fileName, Tau_EMD, Ag_EMD, Number_EMD,EMD_threshold, Ground_truth_threshold, Error_range] = getUserInputsEMD();

%%
% Step 1: EMD Data Import and Preprocessing
path = fullfile('Blender_video_set', fileName);
% Remove the file extension from the file name
[~, name, ~] = fileparts(fileName);
% Set the save path
saveas = fullfile('Blender_video_set', [name '_pp']);
f = preprocessVideo(path, saveas);

%%
% Step 2: EMD Calculation
emd_results = runEMD(f, Tau_EMD, Ag_EMD, Number_EMD, name);

%%
% Step 3: Calculate closest Pillar angle based on EMD result
EMD_object = runEMDToObstacle(emd_results, EMD_threshold);

%%
% Step 4: Calculate Closest Pillar angle based on object information
GroundTruth_object = runGroundtruthToObstacle(name, Ground_truth_threshold);

%%
clc;
fprintf(name);
run_accuracy_calculation1(GroundTruth_object, EMD_object, Error_range);