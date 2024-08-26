function run_accuracy_calculation(GroundTruth_object, FoF_object, FR_object, EMD_object, Error_range)
    % 初始化计数器
    FoF_TN = 0;
    FoF_TP = 0;
    FoF_FN = 0;
    FoF_FP = 0;
    FoF_correct = 0;
    FoF_incorrect = 0;
    FR_TN = 0;
    FR_TP = 0;
    FR_FN = 0;
    FR_FP = 0;
    FR_correct = 0;
    FR_incorrect = 0;
    EMD_TN = 0;
    EMD_TP = 0;
    EMD_FN = 0;
    EMD_FP = 0;
    EMD_correct = 0;
    EMD_incorrect = 0;
    
    % 遍历每一帧
    for i = 1:length(GroundTruth_object)
        basic_value_FOF = FoF_object(i);
        groundtruth_value = GroundTruth_object(i);
        
        if isnan(basic_value_FOF) && isnan(groundtruth_value)
            FoF_TN = FoF_TN + 1; % 两者均为NaN
        elseif ~isnan(basic_value_FOF) && ~isnan(groundtruth_value)
            FoF_TP = FoF_TP + 1; % 两者均不为NaN
            % 比较两个数值之间的差值
            if abs(basic_value_FOF - groundtruth_value) > Error_range
                FoF_incorrect = FoF_incorrect + 1; % 差值大于25
            else
                FoF_correct = FoF_correct + 1; % 差值小于等于25
            end
        elseif isnan(basic_value_FOF) && ~isnan(groundtruth_value)
            FoF_FN = FoF_FN + 1; % BasicTrace1为NaN，Groundtruth不为NaN
        elseif ~isnan(basic_value_FOF) && isnan(groundtruth_value)
            FoF_FP = FoF_FP + 1; % BasicTrace1不为NaN，Groundtruth为NaN
        end
    end
    
    % 遍历每一帧
    for i = 1:length(GroundTruth_object)
        basic_value_FR = FR_object(i);
        groundtruth_value = GroundTruth_object(i);
        
        if isnan(basic_value_FR) && isnan(groundtruth_value)
            FR_TN = FR_TN + 1; % 两者均为NaN
        elseif ~isnan(basic_value_FR) && ~isnan(groundtruth_value)
            FR_TP = FR_TP + 1; % 两者均不为NaN
            % 比较两个数值之间的差值
            if abs(basic_value_FR - groundtruth_value) > Error_range
                FR_incorrect = FR_incorrect + 1; % 差值大于25
            else
                FR_correct = FR_correct + 1; % 差值小于等于25
            end
        elseif isnan(basic_value_FR) && ~isnan(groundtruth_value)
            FR_FN = FR_FN + 1; % BasicTrace1为NaN，Groundtruth不为NaN
        elseif ~isnan(basic_value_FR) && isnan(groundtruth_value)
            FR_FP = FR_FP + 1; % BasicTrace1不为NaN，Groundtruth为NaN
        end
    end
    
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
    
    Accuracy_FoF = (FoF_TN + FoF_TP) / (FoF_TN + FoF_TP + FoF_FN + FoF_FP);
    Correction_FoF = FoF_correct / FoF_TP;
    
    Accuracy_FR = (FR_TN + FR_TP) / (FR_TN + FR_TP + FR_FN + FR_FP);
    Correction_FR = FR_correct / FR_TP;
    
    Accuracy_EMD = (EMD_TN + EMD_TP) / (EMD_TN + EMD_TP + EMD_FN + EMD_FP);
    Correction_EMD = EMD_correct / EMD_TP;
    
    % 打印结果
    fprintf('\nFlow of Flow algorithm accuracy\n');
    fprintf('True Negative (TN): %d\n', FoF_TN);
    fprintf('True Positive (TP): %d\n', FoF_TP);
    fprintf('False Negative (FN): %d\n', FoF_FN);
    fprintf('False Positive (FP): %d\n', FoF_FP);
    fprintf('Correct TP: %d\n', FoF_correct);
    fprintf('Incorrect TP: %d\n', FoF_incorrect);
    fprintf('Accuracy FoF: %.2f%%\n', Accuracy_FoF*100);
    fprintf('Correction FoF: %.2f%%\n', Correction_FoF*100);
    
    % 打印结果
    fprintf('\nFourier Residual algorithm accuracy\n');
    fprintf('True Negative (TN): %d\n', FR_TN);
    fprintf('True Positive (TP): %d\n', FR_TP);
    fprintf('False Negative (FN): %d\n', FR_FN);
    fprintf('False Positive (FP): %d\n', FR_FP);
    fprintf('Correct TP: %d\n', FR_correct);
    fprintf('Incorrect TP: %d\n', FR_incorrect);
    fprintf('Accuracy FR: %.2f%%\n', Accuracy_FR*100);
    fprintf('Correction FR: %.2f%%\n', Correction_FR*100);
    
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