function[sensorDataMatrix] = getNoisySensorData_network(tSensorIDs, T, startTime, endTime)


for i = 1 : length(tSensorIDs)
    sensorID = tSensorIDs(i);
    load(['.\SensorData_validation\' num2str(sensorID) '.mat']);

    % load data from startTime to endTime
    startCell = ceil((startTime*60)/T + 1);
    endCell = floor((endTime*60)/T + 1);
    densityDataSum = densityDataSum(startCell:endCell,1);
    
    sensorDataMatrix(:,i) = densityDataSum;
end