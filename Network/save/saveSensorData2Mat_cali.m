function[] = saveSensorData2Mat_cali(SENSOR_DATA_MATRIX, CONFIG, PARAMETER, sample)

sensorIDs = SENSOR_DATA_MATRIX.keys;

if (exist (['.\Result\testingData\config-' num2str(CONFIG.configID) '\' num2str(sample)], 'dir') ~= 7)
    mkdir (['.\Result\testingData\config-' num2str(CONFIG.configID) '\' num2str(sample)]);
end

for i = 1 : length(sensorIDs)
    
    sensorInfo = SENSOR_DATA_MATRIX(sensorIDs{i});
    
    sensorData = sensorInfo.matrix(:,5);

    % save to testing data folder
    if PARAMETER.trueStateErrorVar == 0
        save(['.\Result\testingData\config-' num2str(CONFIG.configID) '\' num2str(sample) '\' num2str(sensorIDs{i}) '-true'], 'sensorData');
    else
        save(['.\Result\testingData\config-' num2str(CONFIG.configID) '\' num2str(sample) '\' num2str(sensorIDs{i}) '-noisy'], 'sensorData');
    end
end
