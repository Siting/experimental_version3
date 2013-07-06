function[] = saveSensorData2Mat_error(SENSOR_DATA_MATRIX, CONFIG, PARAMETER, sample, simu_evolutionDataFolder)

sensorIDs = SENSOR_DATA_MATRIX.keys;

if (exist ([num2str(simu_evolutionDataFolder) '\' num2str(sample)], 'dir') ~= 7)
    mkdir ([num2str(simu_evolutionDataFolder) '\' num2str(sample)]);
end

for i = 1 : length(sensorIDs)
    
    sensorInfo = SENSOR_DATA_MATRIX(sensorIDs{i});
    
    sensorData = sensorInfo.matrix(:,5);

    % save to testing data folder
    if PARAMETER.trueStateErrorVar == 0
        save([num2str(simu_evolutionDataFolder) '\' num2str(sample) '\' num2str(sensorIDs{i}) '-true'], 'sensorData');
    else
        save([num2str(simu_evolutionDataFolder) '\' num2str(sample) '\' num2str(sensorIDs{i}) '-noisy'], 'sensorData');
    end
end
    