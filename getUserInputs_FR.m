function [numHarmonics] = getUserInputs_FR()
    prompt = {'Enter Number of Harmonics:'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'5'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    numHarmonics = str2double(answer{1});
end
