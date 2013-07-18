function[] = runSimulation(CONFIG,PARAMETER, cali_configID, simu_configID, testSamplingSize, series)

global startTime
global endTime

% load config & para & map
[deltaTinSecond, deltaT, nT, numIntervals, numEns,...
    startString, endString, startTimePara, unixTimeStep, guessedFUNDAMENTAL, trueNodeRatio,...
    vmaxVar, dmaxVar, dcVar, trueNodeRatioVar, modelFirst, modelLast, populationSize,...
    samplingSize, criteria, stateNoiseGamma, measNoiseGamma, etaW, junctionSolverType,...
    numTimeSteps, samplingInterval, trueStateErrorMean, trueStateErrorVar,...
    measConfigID, measNetworkID, caliNetworkID, testingDataFolder, evolutionDataFolder, sensorDataFolder, configID, T] = getConfigAndPara(CONFIG,PARAMETER);
numTimeSteps = (endTime-startTime)*3600/deltaTinSecond;
load([caliNetworkID, '-graph.mat']);
disp([caliNetworkID, '-graph loaded']);
[LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap);
simu_evolutionDataFolder = ['.\ResultCollection\series' num2str(simu_configID)];
mkdir(simu_evolutionDataFolder);
ALL_SAMPLES = initializeAllSamples(linkMap);

% load calibration result
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);
means = meanForRounds(:,:,end);
vars = varForRounds(:,:,end);

times = 1;
for sample = 1 : testSamplingSize
    index = (times-1)*testSamplingSize + sample;

    FUNDAMENTAL = sampleFUNDA(guessedFUNDAMENTAL, vmaxVar, dmaxVar, dcVar);
    % load links
    [LINK] = loadLinks_error(linkMap,FUNDAMENTAL, cali_configID, LINK, means, vars);
    % save samples
    ALL_SAMPLES = saveSamplesForLinks(LINK, ALL_SAMPLES);
    % load node ratio
    [JUNCTION] = loadNodeRatio(cali_configID,JUNCTION,junctionSolverType,LINK);
    % initialize links
    [LINK,numCellsNet] = initializeAllLinks(LINK, deltaT, numEns, CONFIG);
    % set FUNDA for SOURCE, SINK
    [SOURCE_LINK, SINK_LINK] = setFundamentalParameters_network(SOURCE_LINK, SINK_LINK, FUNDAMENTAL, linkMap, LINK);
    % run simulation
    [LINK] = runForwardSimulation(LINK, SOURCE_LINK, SINK_LINK, JUNCTION, deltaT, numEns, numTimeSteps, nT, junctionSolverType);
    % save density results

    saveSimulationResults_error(LINK,sensorMetaDataMap,numEns,numTimeSteps,samplingInterval,...
        startTimePara,unixTimeStep,trueStateErrorMean,trueStateErrorVar, index, configID, simu_evolutionDataFolder, CONFIG, PARAMETER);
    
    if mod(sample, 20) == 0
        disp(['sample ' num2str(sample) ' finished']);
    end
end