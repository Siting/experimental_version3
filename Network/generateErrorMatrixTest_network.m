function[errorMatrix] = generateErrorMatrixTest_network(modelData, sensorData, tSensorIDs)

errorMatrix = -10000 * ones(size(modelData,1), length(tSensorIDs));

for i = 1 : size(errorMatrix,2)
    errorMatrix(:,i) = abs(sensorData(2:end,i) - modelData(:,i));
end