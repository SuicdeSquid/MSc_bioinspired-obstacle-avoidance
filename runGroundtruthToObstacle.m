function GroundTruth_object = runGroundtruthToObstacle(name, Ground_truth_threshold)
    % Set the base directory
    baseDir = 'Object_info';
    
    % Define the file names
    anglesFile = 'pillar_angles.csv';
    distancesFile = 'pillar_distances.csv';
    
    % Define the object_info subfolder
    subDir = name;
    
    % Construct the full file paths
    anglesFilePath = fullfile(baseDir, subDir, anglesFile);
    distancesFilePath = fullfile(baseDir, subDir, distancesFile);
    
    % Read the tables from the constructed file paths
    angles_data = readtable(anglesFilePath);
    distances_data = readtable(distancesFilePath);
    
    % Initialize the closest pillar angles array
    closest_pillar_angles = NaN(height(distances_data), 1);
    
    % Initialize variable to track the previous minimum distance
    previous_min_distance = Inf; % Use Inf to ensure the first comparison is always false
    
    % Find the closest pillar and its angle for each frame
    for i = 1:height(distances_data)
        % Find the minimum distance and corresponding pillar index
        [min_distance, idx] = min(table2array(distances_data(i, 2:end)));
        
        % Ensure the index is within bounds
        if idx > 0 && idx <= width(angles_data) - 1
            % Check if the minimum distance is below the threshold
            if min_distance < Ground_truth_threshold
                % Check for consecutive frames with the same minimum distance
                if min_distance == previous_min_distance
                    closest_pillar_angles(i) = NaN;
                else
                    % Get the angle of the closest pillar
                    closest_pillar_angles(i) = table2array(angles_data(i, idx + 1));
                end
                % Update the previous minimum distance
                previous_min_distance = min_distance;
            else
                % Set the angle to NaN if the distance is above the threshold
                closest_pillar_angles(i) = NaN;
                % Reset previous minimum distance since the threshold is not met
                previous_min_distance = Inf;
            end
        else
            error('Index out of bounds for frame %d', i);
        end
    end
    
    % Return the closest pillar angles as GroundTruth_object
    GroundTruth_object = closest_pillar_angles;
end
