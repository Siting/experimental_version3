function[] = parameterCalibrationABCSMC_network(CONFIG,PARAMETER,configID)

global numStages
global testingSensorIDs
global junctionIndex
global startTime
global endTime
global thresholdVector


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

% nodeIDs = nodeMap.keys;
junctionIndex = 1;

% pre-load links & junctions, also precompute junction lane ratio for
% diverge and merge junctions
tic
[LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, T);
t = toc

% iterate through nodes
% for i = 1 : length(nodeIDs)  
    arForRounds = [];
    meanForRounds = [];
    varForRounds = [];
    timeForRounds = [];
    weightsForRounds = [];
    ALL_SAMPLES = initializeAllSamples(linkMap);

%     if min(nodeMap(nodeIDs{i}).incomingLinks ~= -1) && min(nodeMap(nodeIDs{i}).outgoingLinks ~= -1) % not source | sink
%         disp(['node ' num2str(nodeIDs{i})]);

        for stage = 1 : numStages  % iterate stages
            disp(['stage ' num2str(stage)]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if stage == 1
                stageStart = tic;
                state = true;                
                [ACCEPTED_POP, REJECTED_POP] = initializeAcceptedRejected(linkMap);                
                indexCollection = [];
                times = 1;
                LINKDataFolder = ([evolutionDataFolder num2str(stage) '\']);
                if (exist (LINKDataFolder, 'dir') ~= 7)
                    mkdir(LINKDataFolder);
                end

                while (state)

                    % simulation=============
                    disp('start simulation');
                    
                    for sample = 1 : samplingSize
                        
                        index = (times-1)*samplingSize + sample;
                        
                        % sampling parameters for FUNDAMENTAL diagram
                        FUNDAMENTAL = sampleFUNDA(guessedFUNDAMENTAL, vmaxVar, dmaxVar, dcVar);
                        
                        % Initialize links
                        [LINK, SOURCE_LINK, SINK_LINK, JUNCTION, numCellsNet, ALL_SAMPLES, numLanes] = initializeAll_network(FUNDAMENTAL, linkMap, JUNCTION, deltaT, numEns, CONFIG, ALL_SAMPLES,...
                            SOURCE_LINK, SINK_LINK, junctionSolverType, LINK);
                        
                        % run forward simulation
                        [LINK] = runForwardSimulation(LINK, SOURCE_LINK, SINK_LINK, JUNCTION, deltaT,...
                            numEns, numTimeSteps, nT, junctionSolverType);
                        
                        % save density results
                        saveSimulationResults_network(LINK,sensorMetaDataMap,numEns,numTimeSteps,samplingInterval,...
                            startTimePara,unixTimeStep,trueStateErrorMean,trueStateErrorVar, index, configID, evolutionDataFolder, CONFIG, PARAMETER);
                        
                        if mod(sample, 20) == 0
                            disp(['sample ' num2str(sample) ' finished']);
                        end
                    end
                    
                    % calibration %%%%%%%%%%%%%%%%
                    disp('start calibration');
                    
                    % noisy sensor data
                    [sensorDataMatrix] = getNoisySensorData_network(testingSensorIDs, T);
             
                    % ABC SMC stage 1: filter samples according
                    [ACCEPTED_POP, REJECTED_POP, indexCollection] = ABC_SMC_stage1_type2_network(measConfigID, CONFIG.configID, samplingSize, ALL_SAMPLES,...
                        populationSize, times, ACCEPTED_POP, REJECTED_POP, indexCollection, testingSensorIDs, sensorDataMatrix, nodeMap,...
                        sensorMetaDataMap, linkMap,stage, T, deltaTinSecond);
                    
                    % check accepted population Size
                    if size(ACCEPTED_POP(1).samples,2) >= populationSize 
                         ar = size(ACCEPTED_POP(1).samples,2) / (times*samplingSize);
                         ACCEPTED_POP = trimExessiveSamples(ACCEPTED_POP,populationSize);
                         state = false;
                    elseif size(ACCEPTED_POP(1).samples,2) < populationSize
                        disp(['population size is ' num2str(size(ACCEPTED_POP(1).samples,2)) ', start reasampling.']);
                        times = times + 1;
                    end
                        
                    rmdir(['.\Result\testingData\config-' num2str(configID) '\*'], 's');
                    
                end
                
%                 save([evolutionDataFolder 'node-' num2str(i) '-allRandomSamples'], 'ALL_SAMPLES');               
%                 save([evolutionDataFolder 'node-' num2str(i) '-acceptedPop-stage-' num2str(stage)], 'ACCEPTED_POP');
                save([evolutionDataFolder '-allRandomSamples'], 'ALL_SAMPLES');               
                save([evolutionDataFolder '-acceptedPop-stage-' num2str(stage)], 'ACCEPTED_POP');
                
                % initialize weights
                weights = 1 / size(ACCEPTED_POP(1).samples,2) * ones(1, size(ACCEPTED_POP(1).samples,2));
                
                fclose('all');
                stageT = toc(stageStart);
                timeForRounds = [timeForRounds, stageT];                
                
            else
                stageStart = tic;

                [ACCEPTED_POP, weights, ar] = ABC_SMC_stage2AndLater2_type2_network(measConfigID, configID, samplingSize, criteria,...
                    ACCEPTED_POP, REJECTED_POP, ALL_SAMPLES, weights, populationSize, PARAMETER, CONFIG,...
                    sensorMetaDataMap, LINK, SOURCE_LINK, SINK_LINK, JUNCTION, stage, linkMap, testingSensorIDs,...
                    sensorDataMatrix, nodeMap);
                
%                 save([evolutionDataFolder 'node-' num2str(i) '-acceptedPop-stage-' num2str(stage)], 'ACCEPTED_POP'); 
                save([evolutionDataFolder '-acceptedPop-stage-' num2str(stage)], 'ACCEPTED_POP');   
                fclose('all');
                stageT = toc(stageStart);                
                timeForRounds = [timeForRounds, stageT];

            end
            [meanForLinks, varForLinks] = computeMeanAndVar(ACCEPTED_POP);
             meanForRounds(:,:,stage) = meanForLinks;
             varForRounds(:,:,stage) = varForLinks;
             arForRounds = [arForRounds ar];
             weightsForRounds = [weightsForRounds; weights]; 
%              keyboard

        end
        
        % save results
%         save([evolutionDataFolder 'node-' num2str(i) '-calibrationResult'],'arForRounds', 'meanForRounds', 'varForRounds', 'thresholdVector',...
%             'ACCEPTED_POP', 'timeForRounds', 'weightsForRounds');
          save([evolutionDataFolder '-calibrationResult'],'arForRounds', 'meanForRounds', 'varForRounds', 'thresholdVector',...
    'ACCEPTED_POP', 'timeForRounds', 'weightsForRounds');
%         junctionIndex = junctionIndex + 1;
%     end
    
% end


