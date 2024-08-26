function FoF_object = runFoFToObstacle(fof_results, FoF_threshold)
    % Extract the Complete_frame_FoF variable
    complete_frame_fof = fof_results.Complete_frame_fof;
    
    % Initialize arrays to hold frame numbers and their corresponding weighted average degrees
    frames = [];
    weighted_degrees = [];
    
    % Iterate over all frames
    for i = 1:size(complete_frame_fof, 1)
        % Get the current frame
        frame = complete_frame_fof(i, :);
        
        % Apply thresholding to identify non-zero regions
        non_zero_mask = abs(frame) > FoF_threshold;
        
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
    
    FoF_object = weighted_degrees;

end