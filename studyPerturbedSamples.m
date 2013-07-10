% study rejected samples by stages
clear all
clc

global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs
global sensorDataSource


series = 11;
cali_configID = 41;
cali_paraID = 41;
simu_configID = 112;
firstStage = 3;   % feed in
secondStage = 4;  % retrieve from
numSamplesStudied = 200;
numRounds = 2;
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
sensorDataSource = 2;

% load thresholdVecotr & rejected samples & PARA
for i = 1 : numRounds
    load(['.\ResultCollection\series' num2str(series) '\-sampledAndPertubed-stage-' num2str(secondStage) '-time-' num2str(i) '.mat']);
    if i >= 2
        [POPULATION_2] = saveNewSamples(POPULATION_2, POPULATION_2);
    end
end
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);  % for thresholdVector
load(['.\Configurations\parameters\PARAMETER-' num2str(cali_paraID) '.mat']);
load(['.\Configurations\configs\CONFIG-' num2str(cali_paraID) '.mat']);
FUNDAMENTAL = PARAMETER.FUNDAMENTAL;
load([CONFIG.caliNetworkID, '-graph.mat']);
simu_evolutionDataFolder = ['.\Result\testingData\config-' num2str(simu_configID)];
mkdir(simu_evolutionDataFolder);
numSamples = size(POPULATION_2(1).samples,2);

if numSamplesStudied > numSamples
    numSamplesStudied = numSamples;
end

% noisy sensor data
[sensorDataMatrix] = getNoisySensorData_network(testingSensorIDs, PARAMETER.T,...
    PARAMETER.startTime, PARAMETER.endTime);

% SIMULATION
[LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, PARAMETER.T, PARAMETER.startTime, PARAMETER.endTime);
for sample = 1 : numSamplesStudied
    % extract sample for every link & assign to links
    for i = 1 : length(POPULATION_2)
        FUNDAMENTAL(i).vmax = POPULATION_2(i).samples(1,sample);
        FUNDAMENTAL(i).dmax = POPULATION_2(i).samples(2,sample);
        FUNDAMENTAL(i).dc = POPULATION_2(i).samples(3,sample);
    end
    % run simulation
    runSimulationForSample(FUNDAMENTAL, PARAMETER, CONFIG, simu_configID, sample, simu_evolutionDataFolder,...
        LINK, JUNCTION, SOURCE_LINK, SINK_LINK);    
    
    if mod(sample, 20) == 0
        disp(['sample ' num2str(sample) ' is finished']);
    end
end

% FILTER
[ACCEPTED_POP_NEW, REJECTED_POP_NEW] = initializeAcceptedRejected(linkMap);
sensorSelection = [];
criteria = 0;
for sample = 1 : numSamplesStudied
    % load model density simulation data (first row = initial state)
    [modelDataMatrix] = getModelSimulationDataCumu_network(simu_configID, sample,...
        testingSensorIDs, PARAMETER.T, PARAMETER.deltaTinSecond);
    % create error matrix (density)
    errorMatrix = generateErrorMatrixTest_network(modelDataMatrix, sensorDataMatrix, testingSensorIDs);
    % reject or select?
    [choice, sensorSelection] = rejectAccept_network(errorMatrix, criteria, nodeMap,...
        sensorMetaDataMap, linkMap, firstStage, sensorSelection, PARAMETER.thresholdVector);
    % save

    if strcmp(choice, 'accept')
        ACCEPTED_POP_NEW = saveSample(ACCEPTED_POP_NEW, sample, POPULATION_2);
    elseif strcmp(choice, 'reject')
        REJECTED_POP_NEW = saveSample(REJECTED_POP_NEW, sample, POPULATION_2);
    end
end

acceptanceRate = size(ACCEPTED_POP_NEW(1).samples,2) / numSamplesStudied




