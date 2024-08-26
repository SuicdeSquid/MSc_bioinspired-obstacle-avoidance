function emd_results = runEMD(f, Tau, Ag, Number, name)
    % Initialize EMD with given parameters
    emd = EMD(Tau, Ag, Number);
    
    % Prepare EMD for data processing
    emd = emd.prepareForData(f);
    emd = emd.fillData(f);
    emd = emd.lowPassFilter(f);
    emd = emd.computeResults();
    emd = emd.preparePlot(f);

    % Important section: Extract and show specific frame data
    framenumber = 214;
    emd = emd.showFrame(framenumber);
    single_frame_EMD = emd.RoutSingleFrame(1,:); % Extract data for the specified frame

    % Prepare to save EMD data for all frames
    write = true; 
    saveas = ['Video_info/', name, '_VideoFrameEMDarray.mat'];   
    frameEMD.T = 250;
    frameEMD.Length = Number(:,2);
    frameEMD.Complete_frame_EMD = zeros(frameEMD.T, frameEMD.Length);
    
    % Loop through each frame and store EMD data
    for i = 1:frameEMD.T
        emd = emd.showFrame(i);
        frameEMD.Complete_frame_EMD(i,:) = emd.RoutSingleFrame(1,:);
    end

    % Save the EMD results to a file
    save(saveas, 'frameEMD')
    
    % Return the EMD results
    emd_results = frameEMD;
end
