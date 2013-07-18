function[modelDataMatrix] = getModelSimulation_analyze(simu_configID, sample, testingSensorIDs, T, deltaTinSecond)

c = (T*60)/deltaTinSecond;
for i = 1 : length(testingSensorIDs)
    sensorID = testingSensorIDs(i);
    load(['.\Result\testingData\config-' num2str(simu_configID) '\' num2str(sample) '\' num2str(testingSensorIDs(i)) '-true.mat']);  % pos

    % get cumulative flow
    cumulativeFlow = [];
    for j = 1 : (size(sensorData,1)/c)
        cumu = sum(sensorData(((j-1)*c+1) : (j*c)));
        cumulativeFlow = [cumulativeFlow;cumu];
    end
    modelDataMatrix(:,i) = cumulativeFlow;
end