function run_accuracy_calculation1(GroundTruth_object, EMD_object, Error_range)
    
    EMD_TN = 0;
    EMD_TP = 0;
    EMD_FN = 0;
    EMD_FP = 0;
    EMD_correct = 0;
    EMD_incorrect = 0;

    for i = 1:length(GroundTruth_object)
        basic_value_FOF = EMD_object(i);
        groundtruth_value = GroundTruth_object(i);
        
        if isnan(basic_value_FOF) && isnan(groundtruth_value)
            EMD_TN = EMD_TN + 1; % 两者均为NaN
        elseif ~isnan(basic_value_FOF) && ~isnan(groundtruth_value)
            EMD_TP = EMD_TP + 1; % 两者均不为NaN
            % 比较两个数值之间的差值
            if abs(basic_value_FOF - groundtruth_value) > Error_range
                EMD_incorrect = EMD_incorrect + 1; % 差值大于25
            else
                EMD_correct = EMD_correct + 1; % 差值小于等于25
            end
        elseif isnan(basic_value_FOF) && ~isnan(groundtruth_value)
            EMD_FN = EMD_FN + 1; % BasicTrace1为NaN，Groundtruth不为NaN
        elseif ~isnan(basic_value_FOF) && isnan(groundtruth_value)
            EMD_FP = EMD_FP + 1; % BasicTrace1不为NaN，Groundtruth为NaN
        end
    end
    
    Accuracy_EMD = (EMD_TN + EMD_TP) / (EMD_TN + EMD_TP + EMD_FN + EMD_FP);
    Correction_EMD = EMD_correct / EMD_TP;
    
    % 打印结果
    fprintf('\nRaw EMD algorithm accuracy\n');
    fprintf('True Negative (TN): %d\n', EMD_TN);
    fprintf('True Positive (TP): %d\n', EMD_TP);
    fprintf('False Negative (FN): %d\n', EMD_FN);
    fprintf('False Positive (FP): %d\n', EMD_FP);
    fprintf('Correct TP: %d\n', EMD_correct);
    fprintf('Incorrect TP: %d\n', EMD_incorrect);
    fprintf('Accuracy FoF: %.2f%%\n', Accuracy_EMD*100);
    fprintf('Correction FoF: %.2f%%\n', Correction_EMD*100);

end