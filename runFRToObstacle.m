function FR_object = runFRToObstacle(fr_results, FR_threshold)
    % Extract the Complete_frame_fr variable
    complete_frame_fr = fr_results.Complete_frame_fr;
    
    % Initialize arrays to hold frame numbers and their corresponding weighted average degrees
    frames = [];
    weighted_degrees = [];
    
    % Iterate over all frames
    for i = 1:size(complete_frame_fr, 1)
        % Get the current frame
        frame = complete_frame_fr(i, :);
        
        % Apply thresholding to identify non-zero regions
        non_zero_mask = abs(frame) > FR_threshold;
        
        % Find non-zero values and their locations
        non_zero_values = frame(non_zero_mask);
        non_zero_degrees = find(non_zero_mask);
        
        if ~isempty(non_zero_values)
            % Calculate the weighted average degree
            weighted_average_degree = sum(non_zero_degrees .* abs(non_zero_values)) / sum(abs(non_zero_values));
            degree = 180 - weighted_average_degree;
        else
            degree = NaN; % Output NaN if no values are detected above the threshold
        end
        
        % Store the frame number and its corresponding weighted average degree
        frames = [frames; i];
        weighted_degrees = [weighted_degrees; degree];
    end
    
    FR_object = weighted_degrees;

end