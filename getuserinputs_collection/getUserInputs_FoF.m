function [Tau, Ag, Number] = getUserInputs_FoF()
    prompt = {'Enter Tau:', 'Enter Ag (format: [x,y]):', 'Enter Number (format: [x,y]):'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'1', '[0,1]', '[1,358]'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    Tau = str2double(answer{1});
    Ag = str2num(answer{2}); %#ok<ST2NM>
    Number = str2num(answer{3}); %#ok<ST2NM>
end
