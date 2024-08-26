function [fileName, Tau, Ag, Number] = getUserInputs_EMD()
    prompt = {'Enter file name:', 'Enter Tau_EMD:', 'Enter Ag_EMD (format: [x,y]):', 'Enter Number_EMD (format: [x,y]):'};
    dlgtitle = 'Input';
    dims = [1 50];
    definput = {'Basic_trace1.avi', '1', '[0,1]', '[10,358]'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    fileName = answer{1};
    Tau = str2double(answer{2});
    Ag = str2num(answer{3}); %#ok<ST2NM>
    Number = str2num(answer{4}); %#ok<ST2NM>
end
