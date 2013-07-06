function[modelDataMatrix] = getModelSimulationDataCumu_network(configID, sample, tSensorIDs, T, deltaTinSecond)

c = (T*60)/deltaTinSecond;
for i = 1 : length(tSensorIDs)
    sensorID = tSensorIDs(i);
    load(['.\Result\testingData\config-' num2str(configID) '\' num2str(sample) '\' num2str(sensorID) '-true']);

    % get cumulative flow
    cumulativeFlow = [];
    for j = 1 : (size(sensorData,1)/c)
        cumu = sum(sensorData(((j-1)*c+1) : (j*c)));
        cumulativeFlow = [cumulativeFlow;cumu];
    end
    modelDataMatrix(:,i) = cumulativeFlow;
end
