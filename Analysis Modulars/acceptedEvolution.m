clear all
clc

global boundarySourceSensorIDs
global boundarySinkSensorIDs
global testingSensorIDs
global sensorDataSource
global thresholdChoice

series = 15;
studyLinks = [1;3; 5; 7];
stage = 7;
cali_configID = 41;
cali_paraID = 41;
simu_configID = 118;
numSamplesStudied = 1;
boundarySourceSensorIDs = [400468; 402955; 402954; 402950];
boundarySinkSensorIDs = [402953; 400698];
testingSensorIDs = [400739; 400363];
sensorDataSource = 2;
thresholdChoice = 2;

% load thresholdVecotr & rejected samples & PARA
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);
load(['.\Configurations\parameters\PARAMETER-' num2str(cali_paraID) '.mat']);
load(['.\Configurations\configs\CONFIG-' num2str(cali_paraID) '.mat']);
FUNDAMENTAL = PARAMETER.FUNDAMENTAL;
load([CONFIG.caliNetworkID, '-graph.mat']);
load(['.\ResultCollection\series' num2str(series) '\-acceptedPop-stage-' num2str(stage) '.mat']);
simu_sensorEvolutionDataFolder = ['.\Result\testingData\config-' num2str(simu_configID)];
simu_linkEvolutionDataFolder = ['.\Result\evolutionData\config-' num2str(simu_configID)];
mkdir(simu_sensorEvolutionDataFolder);
mkdir(simu_linkEvolutionDataFolder);
numSamples = size(ACCEPTED_POP(1).samples,2);

if numSamplesStudied > numSamples
    numSamplesStudied = numSamples;
end

% SIMULATION
for sample = 1 : numSamplesStudied
    [LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, PARAMETER.T, PARAMETER.startTime, PARAMETER.endTime);
    % extract sample for every link & assign to links
    for i = 1 : length(ACCEPTED_POP)
        FUNDAMENTAL(i).vmax = ACCEPTED_POP(i).samples(1,sample);
        FUNDAMENTAL(i).dmax = ACCEPTED_POP(i).samples(2,sample);
        FUNDAMENTAL(i).dc = ACCEPTED_POP(i).samples(3,sample);
    end
    % run simulation
    [LINK] = runSimulationForSample(FUNDAMENTAL, PARAMETER, CONFIG, simu_configID, sample, simu_sensorEvolutionDataFolder,...
        LINK, JUNCTION, SOURCE_LINK, SINK_LINK);    
    
    % all links density results
    save([simu_linkEvolutionDataFolder '\LINK-CONFIG-' num2str(cali_configID) '-sample-' num2str(sample)],'LINK');
    
    if mod(sample, 20) == 0
        disp(['sample ' num2str(sample) ' is finished']);
    end
end

% PLOT
for sample = 1 : numSamplesStudied
    
    % load LINK of the sample
    load(['.\Result\evolutionData\config-' num2str(simu_configID) '\LINK-CONFIG-' num2str(cali_configID) '-sample-' num2str(sample) '.mat']);
    
    for j = 1 : length(studyLinks)
        link = studyLinks(j);
        
        % load link density evolution result
        linkDensity_cali = LINK(link).densityResult;
        
        % reshape the 3D matrix
        linkDensity_cali = reshape(linkDensity_cali, [size(linkDensity_cali,1),...
            size(linkDensity_cali,2)*size(linkDensity_cali,3)]);
        
        figure(sample * j)
        imagesc(linkDensity_cali');
 
        title(['Link ' num2str(link) ' density evolution with calibrated parameters.']);
        xlabel('cells');
        ylabel('time');
        set(gca,'yDir','Normal');
        set(gca,'xDir','Normal');
        h = colorbar;
        hold on
        saveas(gcf, ['../Plots\series' num2str(series) '\acceptedEvolution_sample_ ' num2str(sample) '_link_' num2str(link) '.pdf']);
        saveas(gcf, ['../Plots\series' num2str(series) '\acceptedEvolution_sample_ ' num2str(sample) '_link_' num2str(link) '.fig']);
        saveas(gcf, ['../Plots\series' num2str(series) '\acceptedEvolution_sample_ ' num2str(sample) '_link_' num2str(link) '.eps'], 'epsc');
        
    end
end