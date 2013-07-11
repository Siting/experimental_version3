% compute averaged relative error
clear all
clc

global startTime
global endTime
global sensorDataSource
global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs

cali_configID = 41;
simu_configID = 51;
testSamplingSize = 5;
series = 7;
startTime = 4;
endTime = 5.5;   % 0.5 = 30 mins
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
sensorDataSource = 2;  % 2: from real sensor data
load(['.\Configurations\configs\CONFIG-' num2str(cali_configID)]);
parameterID = CONFIG.parameterID;
load(['.\Configurations\parameters\PARAMETER-' num2str(parameterID)]);

runSimulation(CONFIG,PARAMETER, cali_configID, simu_configID, testSamplingSize, series);