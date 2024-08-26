function [FoF_threshold, FR_threshold, Ground_truth_threshold, Error_range] = getUserInputs_threshold()
    prompt = {'Enter Threshold for FOF calculation:', 'Enter Threshold for FR calculation:', 'Enter Threshold for Ground truth calculation:', 'Enter allowed error range (degree):'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'100', '100', '0.3', '25'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    FoF_threshold = str2double(answer{1});
    FR_threshold = str2num(answer{2}); %#ok<ST2NM>
    Ground_truth_threshold = str2num(answer{3}); %#ok<ST2NM>
    Error_range = str2num(answer{4});
end