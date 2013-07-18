clear all
clc

global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs
global sensorDataSource

series = 15;
stage = 7;
numSamplesStudied = 3;
startTimeStamp = 5;
studyLinks = [1; 3; 5; 7];
cali_configID = 41;
cali_paraID = 41;
simu_configID = series + 100;
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
sensorDataSource = 2;

% load prior and posterior
fileName = (['.\Configurations\fundamental_setting\FUN_CONFIG-' num2str(cali_configID) '.csv']);
fid=fopen(fileName);
funForLinks=textscan(fid,'%d %f %f %f %f %f %f','delimiter',',','headerlines',1);
vmax_mean = funForLinks{2};
dmax_mean = funForLinks{3};
dc_mean = funForLinks{4};
vmax_var = funForLinks{5};
dmax_var = funForLinks{6};
dc_var = funForLinks{7};
fclose(fid);
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);

% load CONFIG & PARA &...
load(['.\Configurations\configs\CONFIG-' num2str(cali_paraID) '.mat']);
load(['.\Configurations\parameters\PARAMETER-' num2str(cali_paraID) '.mat']);
load([CONFIG.caliNetworkID, '-graph.mat']);

% directories
simu_sensorEvolutionDataFolder = ['.\Result\testingData\config-' num2str(simu_configID)];
simu_linkEvolutionDataFolder = ['.\Result\evolutionData\config-' num2str(simu_configID)];
mkdir(simu_sensorEvolutionDataFolder);
mkdir(simu_linkEvolutionDataFolder);

% load noisy sensor data
[sensorDataMatrix] = getNoisySensorData_network(testingSensorIDs, PARAMETER.T,...
    PARAMETER.startTime, PARAMETER.endTime);

% SIMULATION
for sample = 1 : (2 * numSamplesStudied)
    [LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, PARAMETER.T, PARAMETER.startTime, PARAMETER.endTime);
    
    % extract sample for every link & assign to links
    for i = 1 : size(meanForRounds,2)
        if sample <= 1 * numSamplesStudied
            guessed_FUNDAMENTAL.vmax = vmax_mean(i);
            guessed_FUNDAMENTAL.dmax = dmax_mean(i);
            guessed_FUNDAMENTAL.dc = dc_mean(i);
            [FUNDAMENTAL(i)] = sampleFUNDA(guessed_FUNDAMENTAL, vmax_var(i), dmax_var(i), dc_var(i));           
        else
            guessed_FUNDAMENTAL.vmax = meanForRounds(1, i, stage);
            guessed_FUNDAMENTAL.dmax = meanForRounds(2, i, stage);
            guessed_FUNDAMENTAL.dc = meanForRounds(3, i, stage);
            [FUNDAMENTAL(i)] = sampleFUNDA(guessed_FUNDAMENTAL,...
                varForRounds(1, i, stage), varForRounds(2, i, stage), varForRounds(3, i, stage)); 
        end

    end
    
    % run simulation
    [LINK] = runSimulationForSample(FUNDAMENTAL, PARAMETER, CONFIG, simu_configID, sample, simu_sensorEvolutionDataFolder,...
        LINK, JUNCTION, SOURCE_LINK, SINK_LINK);
    
    % all links density results
    save([simu_linkEvolutionDataFolder '\LINK-CONFIG-' num2str(cali_configID) '-sample-' num2str(sample)],'LINK');
    
    % get model simulation data (cumulative)
    modelDataMatrix = getModelSimulation_analyze(simu_configID, sample, testingSensorIDs, PARAMETER.T, PARAMETER.deltaTinSecond);
    
    % save cumulative density Matrix
    save([simu_sensorEvolutionDataFolder '\' num2str(sample) '\cumuDensity'],'modelDataMatrix');
    
    if mod(sample, 20) == 0
        disp(['sample ' num2str(sample) ' is finished']);
    end
end

keyboard
% PLOT
figure
for i = 1 : length(testingSensorIDs)
    
    subplot(2,1,i)
    
    for j = 1 : (1 * numSamplesStudied)
        load(['.\Result\testingData\config-' num2str(simu_configID) '\' num2str(j) '\cumuDensity.mat']);  % prior
        density = modelDataMatrix(:,i);
        h(1) = plot(density(startTimeStamp:end),'r');
        hold on
    end
    
    for j = (numSamplesStudied+1) : (2 * numSamplesStudied)
        load(['.\Result\testingData\config-' num2str(simu_configID) '\' num2str(j) '\cumuDensity.mat']);  % prior
        density = modelDataMatrix(:,i);
        h(2) = plot(density(startTimeStamp:end),'k');
    end
    
    sensorData = sensorDataMatrix(:,i);
    plot(sensorData(startTimeStamp+1:end), 'g');
    xlabel('time');
    ylabel('density');
    legend(h,'prior', 'posterior','true');
    hold off
    keyboard
    saveas(gcf, ['../Plots\series' num2str(series) '\predictionSensorPriorVsPos_sensor_ ' num2str(testingSensorIDs(i)) '_samples.pdf']);
    saveas(gcf, ['../Plots\series' num2str(series) '\predictionSensorPriorVsPos_sensor_ ' num2str(testingSensorIDs(i)) '_samples.fig']);
    saveas(gcf, ['../Plots\series' num2str(series) '\predictionSensorPriorVsPos_sensor_ ' num2str(testingSensorIDs(i)) '_samples.eps'], 'epsc');
end
