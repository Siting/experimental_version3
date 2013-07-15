% study rejected samples by stages
clear all
clc

global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs
global sensorDataSource
global thresholdChoice

series = 15;
studyStages = [7];
numSamplesStudied = 5;
cali_configID = 41;
cali_paraID = 41;
simu_configID = 115;
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
sensorDataSource = 2;
thresholdChoice = 2;

% load thresholdVecotr & PARA & CONFIG
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);
load(['.\Configurations\parameters\PARAMETER-' num2str(cali_paraID) '.mat']);
load(['.\Configurations\configs\CONFIG-' num2str(cali_paraID) '.mat']);
FUNDAMENTAL = PARAMETER.FUNDAMENTAL;
load([CONFIG.caliNetworkID, '-graph.mat']);
simu_evolutionDataFolder = ['.\Result\testingData\config-' num2str(simu_configID)];
mkdir(simu_evolutionDataFolder);

% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y');
stagesString = [];
for i = 1 : length(studyStages)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i))]];
end

% noisy sensor data
[sensorDataMatrix] = getNoisySensorData_network(testingSensorIDs, PARAMETER.T,...
    PARAMETER.startTime, PARAMETER.endTime);

for i = 1 : length(studyStages)   % iterate through stages
    
    load(['.\ResultCollection\series' num2str(series)...
        '\-acceptedPop-stage-' num2str(studyStages(i)) '.mat']);
    
    numSamples = size(ACCEPTED_POP(1).samples,2);
    if numSamplesStudied > numSamples
        numSamplesStudied = numSamples;
    end
    
    % SIMULATION
    [LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, PARAMETER.T, PARAMETER.startTime, PARAMETER.endTime);
    for sample = 1 : numSamplesStudied    % iterate through samples
        % extract sample for every link & assign to links
        for j = 1 : length(ACCEPTED_POP)
            FUNDAMENTAL(j).vmax = ACCEPTED_POP(j).samples(1,sample);
            FUNDAMENTAL(j).dmax = ACCEPTED_POP(j).samples(2,sample);
            FUNDAMENTAL(j).dc = ACCEPTED_POP(j).samples(3,sample);
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
    errorCollectionForStage = [];
    criteria = 0;
    for sample = 1 : numSamplesStudied
        % load model density simulation data (first row = initial state)
        [modelDataMatrix] = getModelSimulationDataCumu_network(simu_configID, sample,...
            testingSensorIDs, PARAMETER.T, PARAMETER.deltaTinSecond);
        % create error matrix (density)
        errorMatrix = generateErrorMatrixTest_network(modelDataMatrix, sensorDataMatrix, testingSensorIDs);
        % reject or select?
        if thresholdChoice == 1
            [choice, sensorSelection, sampleError] = rejectAccept_network(errorMatrix, criteria, nodeMap,...
                sensorMetaDataMap, linkMap, studyStages(i), sensorSelection, PARAMETER.thresholdVector);
        elseif thresholdChoice == 2
            thresholdVector(studyStages(i),:) = [criteriaForRounds(studyStages(i)) criteriaForRounds(studyStages(i))];
            [choice, sensorSelection, sampleError] = rejectAccept_network(errorMatrix, criteria, nodeMap,...
                sensorMetaDataMap, linkMap, studyStages(i), sensorSelection, thresholdVector);
        end
        
        errorCollectionForStage = [errorCollectionForStage sampleError];
    end
    
    % sort array in ascending order
    errorArrayStages(:,i) = sort(errorCollectionForStage, 'ascend');
    keyboard
    matrixSize = size(sensorDataMatrix(:,1),1);

    relativeErrorStages(:,i) = max(errorArrayStages(:,i) / ( 1/matrixSize * norm(sensorDataMatrix(:,1))),...
        errorArrayStages(:,i) / ( 1/matrixSize * norm(sensorDataMatrix(:,2))));
    
    newRelativeError = mean(errorMatrix(2:end,1)./sensorDataMatrix(3:end,1))

end

figure
subplot(2,1,1)
boxplot(errorArrayStages);
xlabel('Stage');
ylabel('Absolute error');

hold on

subplot(2,1,2)
boxplot(relativeErrorStages);
xlabel('Stage');
ylabel('Relative error');
saveas(gcf, ['../Plots\series' num2str(series) '\errorDistributionOfpreSavedSamples.pdf']);
saveas(gcf, ['../Plots\series' num2str(series) '\errorDistributionOfpreSavedSamples.fig']);
saveas(gcf, ['../Plots\series' num2str(series) '\errorDistributionOfpreSavedSamples.eps'], 'epsc');





