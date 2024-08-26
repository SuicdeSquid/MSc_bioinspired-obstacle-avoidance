function [fileName, Tau_EMD, Ag_EMD, Number_EMD, Tau_FoF, Ag_FoF, Number_FoF, numHarmonics, FoF_threshold, FR_threshold, EMD_threshold, Ground_truth_threshold, Error_range] = getUserInputs()
    % Define the prompts for each set of inputs
    prompts = {
        'Enter file name:', 'Enter Tau_EMD:', 'Enter Ag_EMD (format: [x,y]):', 'Enter Number_EMD (format: [x,y]):', ...
        'Enter Tau_FoF:', 'Enter Ag_FoF (format: [x,y]):', 'Enter Number_FoF (format: [x,y]):', ...
        'Enter Number of Harmonics for Fourier Residual Calculation:', ...
        'Enter Threshold for FOF calculation:', 'Enter Threshold for FR calculation:','Enter Threshold for raw EMD calculation:', 'Enter Threshold for Ground truth calculation: (unit:m)', 'Enter allowed error range (degree):'
    };
    
    % Define the dialog title and dimensions
    dlgtitle = 'Input';
    dims = [1 50];
    
    % Define default inputs
    definput = {
        'Indoor_trace1.avi', '1', '[0,1]', '[10,358]', ...
        '1', '[0,1]', '[1,358]', ...
        '50', ...
        '50000000', '100','100', '0.3', '25'
    };
    
    % Display input dialog and get the user's inputs
    answer = inputdlg(prompts, dlgtitle, dims, definput);
    
    % Assign inputs to corresponding variables
    fileName = answer{1};
    Tau_EMD = str2double(answer{2});
    Ag_EMD = str2num(answer{3}); %#ok<ST2NM>
    Number_EMD = str2num(answer{4}); %#ok<ST2NM>
    
    Tau_FoF = str2double(answer{5});
    Ag_FoF = str2num(answer{6}); %#ok<ST2NM>
    Number_FoF = str2num(answer{7}); %#ok<ST2NM>
    
    numHarmonics = str2double(answer{8});
    
    FoF_threshold = str2double(answer{9});
    FR_threshold = str2num(answer{10}); %#ok<ST2NM>
    EMD_threshold = str2num(answer{11}); %#ok<ST2NM>
    Ground_truth_threshold = str2num(answer{12}); %#ok<ST2NM>
    Error_range = str2num(answer{13});
end
