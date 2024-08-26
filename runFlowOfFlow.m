function fof_results = runFlowOfFlow(emd_results, Tau, Ag, Number, name)
    % Initialize FlowofFlow with given parameters
    FlowofFlow_emd = FlowofFlow(Tau, Ag, Number);
    
    % Prepare FlowofFlow for data processing
    FlowofFlow_emd = FlowofFlow_emd.prepareForData(emd_results);
    FlowofFlow_emd = FlowofFlow_emd.fillData(emd_results);
    FlowofFlow_emd = FlowofFlow_emd.lowPassFilter(emd_results);

    % Important section: Extract and show specific frame data
    framenumber = 214;
    FlowofFlow_emd = FlowofFlow_emd.showFrame(emd_results, framenumber);
    single_frame_EMD = FlowofFlow_emd.RoutSingleFrame(1,:); % Extract data for the specified frame

    % Prepare to save FlowofFlow data for all frames
    write = true; 
    saveas = ['Video_info/', name, '_VideoFrameFoFarray.mat'];  
    framefof.T = 250;
    framefof.Length = Number(:,2);
    framefof.Complete_frame_fof = zeros(framefof.T, framefof.Length - 1);
    
    % Loop through each frame and store FlowofFlow data
    for i = 1:framefof.T
        FlowofFlow_emd = FlowofFlow_emd.showFrame(emd_results, i);
        framefof.Complete_frame_fof(i,:) = FlowofFlow_emd.RoutSingleFrame(1,:);
    end

    % Save the FlowofFlow results to a file
    save(saveas, 'framefof')
    
    % Return the FlowofFlow results
    fof_results = framefof;
end
