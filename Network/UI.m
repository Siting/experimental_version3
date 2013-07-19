% This file is for testing network case
clear all
clc
dbstop if error

global map
global arForEveryRound
global ABC_selection_type
global perturbationFactor
global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs
global funsOption
global sensorDataSource
global thresholdChoice
global expectAR


% name the index of configuration(s) 
configID = [41];

% boundary sensorIDs & testing sensorIDs
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
funsOption = 2;    % 1: uniform,  2:non-uniform
sensorDataSource = 2;  % 2: from real sensor data
thresholdChoice = 2;  % 1: manually 2:adaptive
expectAR = 0.2;

ABC_selection_type = 2;

% 1: excel, 2: mat
map = 2;

% 1: set AR, 2: set thresholds
if ABC_selection_type == 1
    numStages = 10;
    arForEveryRound = 0.5;
elseif ABC_selection_type == 2
    perturbationFactor = 0.1;
end


for i = 1 : length(configID)
    configuration_setting(configID);
    disp(['i = ' num2str(i)]);
    runConfigTest(configID(i), i);
end


