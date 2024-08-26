clc;
clear all;
close all;

% Get user input parameters
% [fileName, Tau, Ag, Number] = getUserInputs_EMD();
[fileName, Tau_EMD, Ag_EMD, Number_EMD, Tau_FoF, Ag_FoF, Number_FoF, ... % Flow of Flow calculation
    numHarmonics,...% Fourier Residual Calculation
    FoF_threshold, FR_threshold, EMD_threshold, Ground_truth_threshold, Error_range] = getUserInputs();

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
% Get user input parameters
% [Tau_FoF, Ag_FoF, Number_FoF] = getUserInputs_FoF();

%%
% Step 3: Flow of Flow Calculation
fof_results = runFlowOfFlow(emd_results, Tau_FoF, Ag_FoF, Number_FoF, name);

%%
% Get user input parameter for Fourier Residual calculation
% [numHarmonics] = getUserInputs_FR();

%%
% Step 4: Fourier Residual Calculation
fr_results = runFourierResidual(emd_results, numHarmonics, name);

%%
% Get user input parameter for threshold of FoF object detection, FR object
% detection and ground truth object detection
% [FoF_threshold, FR_threshold, Ground_truth_threshold, Error_range] = getUserInputs_threshold();

%%
% Step 5: Calculate Closest Pillar angle based on object information
GroundTruth_object = runGroundtruthToObstacle(name, Ground_truth_threshold);

%%
% Step 6: Calculate closest Pillar angle based on FoF calculation result
FoF_object = runFoFToObstacle(fof_results, FoF_threshold);

%%
% Step 7: Calculate closest Pillar angle based on FR calculation result
FR_object = runFRToObstacle(fr_results, FR_threshold);

%%
% % Step 8: Calculate closest Pillar angle based on EMD result
EMD_object = runEMDToObstacle(emd_results, EMD_threshold);

%%
% Step 9: Accuracy Calculation
clc;
fprintf(name);
run_accuracy_calculation(GroundTruth_object, FoF_object, FR_object,EMD_object, Error_range);
