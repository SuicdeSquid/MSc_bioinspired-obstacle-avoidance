function  fr_results = runFourierResidual(emd_results, numHarmonics, name)
    opticFlow = emd_results.Complete_frame_EMD; % 300x190 array
    numFrames = size(opticFlow, 1);
    numPoints = size(opticFlow, 2);
    
    % Parameters for Fourier decomposition
    N = numHarmonics; % Number of harmonics
    k0 = 1;
    c_psi = 0.25;
    c_d = 0.5;

    write = true; 
    saveas = ['Video_info/', name, '_VideoFrameFRarray.mat'];  
    for idx = 1:numFrames
        Q_dot = opticFlow(idx, :);
        
        % Fourier series decomposition
        gamma = linspace(-pi, pi, numPoints);
        a0 = mean(Q_dot);
        an = zeros(1, N);
        bn = zeros(1, N);
        for n = 1:N
            an(n) = (1/pi) * sum(Q_dot .* cos(n * gamma))*2*pi/190;
            bn(n) = (1/pi) * sum(Q_dot .* sin(n * gamma))*2*pi/190;
        end
        
        % Reconstruct wide-field (WF) optic flow
        Q_dot_WF = a0/2 + sum(an' .* cos((1:N)' * gamma) + bn' .* sin((1:N)' * gamma), 1);
        
        % Calculate Fourier Residual
        R_FS = Q_dot - Q_dot_WF;
        framefr.Complete_frame_fr(idx,:) = R_FS;
    end
    save(saveas, 'framefr')
    
    fr_results = framefr;
   
end