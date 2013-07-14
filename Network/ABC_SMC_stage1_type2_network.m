function[ACCEPTED_POP, REJECTED_POP, indexCollection, errorCollectionForStage] = ABC_SMC_stage1_type2_network(measConfigID, configID, samplingSize, ALL_SAMPLES,...
    populationSize, times, ACCEPTED_POP, REJECTED_POP, indexCollection, tSensorIDs, sensorDataMatrix, nodeMap, sensorMetaDataMap, linkMap,...
    stage, T, deltaTinSecond, thresholdVector, errorCollectionForStage)

% criteria = thresholdVector(junctionIndex, 1);
criteria = 0;

% start model parameter calibration
sensorSelection = [];
for sample = ((times-1)*samplingSize + 1) : (times * samplingSize)
    
    % load model density simulation data (first row = initial state)
    [modelDataMatrix] = getModelSimulationDataCumu_network(configID, sample, tSensorIDs, T, deltaTinSecond);

    % create error matrix (density)
    errorMatrix = generateErrorMatrixTest_network(modelDataMatrix, sensorDataMatrix, tSensorIDs);

    % reject or select?
    [choice, sensorSelection, sampleError] = rejectAccept_network(errorMatrix, criteria, nodeMap, sensorMetaDataMap,...
        linkMap, stage, sensorSelection, thresholdVector);

    % store in population matrix
    if strcmp(choice, 'accept')
        ACCEPTED_POP = saveSample(ACCEPTED_POP, sample, ALL_SAMPLES);
        indexCollection = [indexCollection, sample];
        errorCollectionForStage = [errorCollectionForStage sampleError];
    elseif strcmp(choice, 'reject')
        REJECTED_POP = saveSample(REJECTED_POP, sample, ALL_SAMPLES);
    end
    

    
end

% % %============
% sensorSelection = sum(sensorSelection);
% ar1 = sensorSelection(1) / samplingSize;
% ar2 = sensorSelection(2) / samplingSize;
% keyboard
