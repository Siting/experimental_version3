function[NEW_ACCEPTED_POP, newWeights, ar, NEW_REJECTED_POP, errorCollectionForStage, thresholdVector, criteriaForStage] = ABC_SMC_stage2AndLater2_type2_network(measConfigID, configID, samplingSize, criteria,...
                    ACCEPTED_POP, REJECTED_POP, ALL_SAMPLES, oldWeights, populationSize, PARAMETER, CONFIG,...
                    sensorMetaDataMap, LINK, SOURCE_LINK, SINK_LINK, JUNCTION, stage, linkMap, testingSensorIDs,...
                    sensorDataMatrix, nodeMap, errorCollectionForStage)
                
global thresholdChoice
   
condition = true;
[NEW_ACCEPTED_POP, NEW_REJECTED_POP] = initializeAcceptedRejected(linkMap);
newWeights = [];
times = 1;
existedLinks = 0;

LINKDataFolder = ([CONFIG.evolutionDataFolder num2str(stage) '\']);
if (exist (LINKDataFolder, 'dir') ~= 7)
    mkdir(LINKDataFolder);
end

% pick threshold based on the error distribution from the previous stage
if thresholdChoice == 2
    [thresholdVector, criteriaForStage] = pickThresholdValue(stage, configID);
elseif thresholdChoice == 1
    thresholdVector = PARAMETER.thresholdVector;
end

while(condition)

    % draw samples from old population (the same size as prior accepted
    % population)
    [POPULATION_1, indexCollection_1] = sampleFromPreviousPop(ACCEPTED_POP, oldWeights);

    % perturb samples
    [POPULATION_2] = perturbSamples(POPULATION_1);

    % update Fundamental for links etc, and then run simulation
    disp('start simulation');
    [LINK, SOURCE_LINK, SINK_LINK, JUNCTION, T, deltaTinSecond] = updateFunAndSimulate_type2_network(POPULATION_2, LINK, SOURCE_LINK, SINK_LINK, JUNCTION,...
        CONFIG, PARAMETER, indexCollection_1, sensorMetaDataMap, configID, stage, linkMap);

    % filter samples, accept or reject?
    disp('start calibration');
    [POPULATION_3, POPULATION_4, indexCollection_2, filteredWeights, errorCollectionForStage] = filterSamples_type2_network(POPULATION_2, indexCollection_1, oldWeights,...
        configID, measConfigID, stage, sensorDataMatrix, testingSensorIDs, linkMap, nodeMap, sensorMetaDataMap,...
        T, deltaTinSecond, thresholdVector, errorCollectionForStage);
    
    if times <= 5
        save([CONFIG.evolutionDataFolder '-sampledAndPertubed-stage-' num2str(stage) '-time-' num2str(times)], 'POPULATION_1', 'POPULATION_2',...
            'POPULATION_3', 'POPULATION_4');
    end

    if size(POPULATION_3(1).samples, 2) == 0 
        disp('round population size 0 after filtering');
        continue;
    end

%     % save filtered LINKs
%     saveFilteredLinks(LINKDataFolder, indexCollection_2, CONFIG.evolutionDataFolder, configID, existedLinks, populationSize);
    
    % save
    NEW_ACCEPTED_POP = saveNewSamples(NEW_ACCEPTED_POP, POPULATION_3);
    NEW_REJECTED_POP = saveNewSamples(NEW_REJECTED_POP, POPULATION_4);
    
    % take one out use as example
    newAcceptedPop1 = NEW_ACCEPTED_POP(1).samples;
    % check population size
    if size(newAcceptedPop1,2) >= populationSize
        ar = size(newAcceptedPop1,2) / (times * length(oldWeights));
        NEW_ACCEPTED_POP = trimExessiveSamples(NEW_ACCEPTED_POP,populationSize);
        %% update weights
        newWeights = updateWeights(NEW_ACCEPTED_POP, oldWeights, ACCEPTED_POP, configID, linkMap, nodeMap);
        weightSum = sum(newWeights);
        newWeights = newWeights ./ weightSum;
        condition = false;
    elseif size(newAcceptedPop1,2) < populationSize
        disp(['population size is ' num2str(size(newAcceptedPop1,2)) ', start reasampling.']);
        condition = true;
        existedLinks = existedLinks + size(POPULATION_3(1).samples, 2);
        times = times + 1;
    end
end