function[LINK, SOURCE_LINK, SINK_LINK, JUNCTION, T, deltaTinSecond] = updateFunAndSimulate_type2_network(POPULATION_2, LINK, SOURCE_LINK, SINK_LINK, JUNCTION,...
    CONFIG, PARAMETER, indexCollection_1, sensorMetaDataMap, configID, stage, linkMap)

global funsOption

% delete previous population result which being saved in the testingData
% folder
rmdir(['.\Result\testingData\config-' num2str(configID)], 's');

[deltaTinSecond, deltaT, nT, numIntervals, numEns, startTime, endTime,...
    startTimeOld, unixTimeStep, FUNDAMENTAL, trueNodeRatio, vmaxVar, dmaxVar,...
    dcVar, trueNodeRatioVar, modelFirst, modelLast, populationSize,...
    samplingSize, criteria, stateNoiseGamma, measNoiseGamma, etaW, junctionSolverType,...
    numTimeSteps, samplingInterval, trueStateErrorMean, trueStateErrorVar,...
    measConfigID, measNetworkID, caliNetworkID, testingDataFolder, evolutionDataFolder,...
    sensorDataFolder, configID, T, thresholdVector] = getConfigAndPara(CONFIG,PARAMETER);
numTimeSteps = (endTime-startTime)*3600/deltaTinSecond;

% iterate through samples
for sample = 1 : size(POPULATION_2(1).samples,2)
    
    if funsOption == 1
        pop = population_2(:,sample);
        
        % save to FUNDAMENTAL
        FUNDAMENTAL.vmax = pop(1);
        FUNDAMENTAL.dmax = pop(2);
        FUNDAMENTAL.dc = pop(3);
    end
    
    % update
    [LINK, SOURCE_LINK, SINK_LINK, JUNCTION] = updateFundamentalFor_network(LINK, SOURCE_LINK, SINK_LINK, JUNCTION, FUNDAMENTAL,...
        deltaT, numEns, CONFIG, linkMap, POPULATION_2, sample);
    
    % run simulation
    [LINK] = runForwardSimulation(LINK, SOURCE_LINK, SINK_LINK, JUNCTION, deltaT, numEns, numTimeSteps, nT, junctionSolverType);
    
    % save
    saveSimulationResults_network(LINK,sensorMetaDataMap,numEns,numTimeSteps,samplingInterval,...
        startTime,unixTimeStep,trueStateErrorMean,trueStateErrorVar, sample, configID, evolutionDataFolder,...
        CONFIG, PARAMETER);

    if mod(sample, 50) == 0
        disp(['sample ' num2str(sample) ' finished']);
    end
end
    