% compute averaged relative error
clear all
clc

configID = 41;
series = 7;
samplingSize = 5;
sensorIDs = [400363; 400739];
% load sensor data
sensorDataMatrix = [];
for i = 1 : length(sensorIDs)
    sensorID = sensorIDs(i);
    load(['.\SensorData_validation\' num2str(sensorID) '.mat']);
    sensorDataMatrix = [sensorDataMatrix densityDataSum];
end
% load calibration result
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);
means = meanForRounds(:,:,end);
vars = varForRounds(:,:,end);

% 
errorMatrix = [];
for i = 1 : samplingSize
    % draw samples for each link
    sample = [];
    for j = 1 : size(means,2)
        sample(:,j) = normrnd(means(:,j), sqrt(vars(:,j)), 3, 1);
        if any(sample(:,j) <= 0) || sample(2,j) <= sample(3,j)
            continue
        end
    end
    
    % run simulation
    runSimulation(sample, configID, series);
end