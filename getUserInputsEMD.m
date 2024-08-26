function [fileName, Tau_EMD, Ag_EMD, Number_EMD,EMD_threshold, Ground_truth_threshold, Error_range] = getUserInputsEMD()
    prompt = {'Enter file name:', 'Enter Tau_EMD:', 'Enter Ag_EMD (format: [x,y]):', 'Enter Number_EMD (format: [x,y]):', ...
        'Enter EMD threshold:','Enter Threshold for Ground truth calculation: (unit:m)', 'Enter allowed error range (degree):'};
    dlgtitle = 'Input';
    dims = [1 50];
    definput = {'Indoor_trace1.avi', '1', '[0,1]', '[10,358]', '10000', '0.5', '25'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    fileName = answer{1};
    Tau_EMD = str2double(answer{2});
    Ag_EMD = str2num(answer{3}); %#ok<ST2NM>
    Number_EMD = str2num(answer{4}); %#ok<ST2NM>
    
    EMD_threshold = str2num(answer{5}); %#ok<ST2NM>
    Ground_truth_threshold = str2num(answer{6}); %#ok<ST2NM>
    Error_range = str2num(answer{7});%#ok<ST2NM>


end