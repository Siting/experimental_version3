function[ACCEPTED_POP, REJECTED_POP, indexCollectionPost, filteredWeights, errorCollectionForStage] = filterSamples_type2_network(POPULATION_2, indexCollection_1, oldWeights,...
    configID, measConfigID, stage, sensorDataMatrix, tSensorIDs, linkMap, nodeMap, sensorMetaDataMap,...
    T, deltaTinSecond, thresholdVector, errorCollectionForStage)

% NOTE: there are two kind of indexes involved in the function.
% 1st: sample index. Which is the index indicating which sample being
% selected from the previous population.
% 2nd: population index. In order to avoid the chaos caused by repeated
% selection samples (e.g. sampel 2 being selected 3 times), we save the
% simulation result of each sample based on their order in the selected
% population(i.e. 1,2,3,4,5...).

% criteria = thresholdVector(junctionIndex, stage);
criteria = 0;

[ACCEPTED_POP, REJECTED_POP] = initializeAcceptedRejected(linkMap);
indexCollectionPost = [];       % index of the sample which is kept
filteredWeights = [];           % weights of the samples which are kept
sensorSelection = [];
for sample = 1 : length(oldWeights)
    
%     % get sample vector
%     s = priorPop(:, sample);
    
    % extract sample info
    index = indexCollection_1(sample);
    w = oldWeights(sample);

    % load model density simulation data (first row = initial state)
    [modelDataMatrix] = getModelSimulationDataCumu_network(configID, sample, tSensorIDs, T, deltaTinSecond);
    
    if any(modelDataMatrix < 0)
        keyboard
    end
    
    % create error matrix (density)
    errorMatrix = generateErrorMatrixTest_network(modelDataMatrix, sensorDataMatrix, tSensorIDs);

    % reject or select?
    [choice, sensorSelection, sampleError] = rejectAccept_network(errorMatrix, criteria, nodeMap, sensorMetaDataMap,...
        linkMap, stage, sensorSelection, thresholdVector);
    
    % store in population matrix
    if strcmp(choice, 'accept')
        ACCEPTED_POP = saveSample(ACCEPTED_POP, sample, POPULATION_2);
        indexCollectionPost = [indexCollectionPost index];
        filteredWeights = [filteredWeights w];
        errorCollectionForStage = [errorCollectionForStage sampleError];
    elseif strcmp(choice, 'reject')
        REJECTED_POP = saveSample(REJECTED_POP, sample, POPULATION_2);
    end
    
    if mod(sample, 80) == 0
        disp(['sample ' num2str(sample) ' filtering finished']);
    end
    
end