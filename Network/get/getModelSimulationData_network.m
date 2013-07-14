function[modelDataMatrix] = getModelSimulationData_network(configID, sample, tSensorIDs)

for i = 1 : length(tSensorIDs)
    sensorID = tSensorIDs(i);
    load(['.\Result\testingData\config-' num2str(configID) '\' num2str(sample) '\' num2str(sensorID) '-true']);
    modelDataMatrix(:,i) = sensorData;
end