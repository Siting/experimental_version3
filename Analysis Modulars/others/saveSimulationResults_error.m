function[] = saveSimulationResults_error(LINK,sensorMetaDataMap_updated,numEns,numTimeSteps,samplingInterval,...
    startTime,unixTimeStep,trueStateErrorMean,trueStateErrorVar, index, configID, simu_evolutionDataFolder,...
    CONFIG, PARAMETER)

% save density result for all timesteps as .mat file
% the first and last cell
[SENSOR_DATA_MATRIX, SENSOR_CELL_INDEX, LINK_WITH_SENSOR] = createTxtFileMatrix(LINK,sensorMetaDataMap_updated,numEns,numTimeSteps,samplingInterval,...
    startTime,unixTimeStep,trueStateErrorMean,trueStateErrorVar);

% % write text file for each sample
% sampleDataFolder = [testingDataFolder num2str(index) '\'];
% if (exist (sampleDataFolder, 'dir') ~= 7)
%     mkdir(sampleDataFolder);
% end
% writeTxtFile(SENSOR_DATA_MATRIX, sampleDataFolder, trueStateErrorVar);


% save([evolutionDataFolder 'measurements-CONFIG-' num2str(configID) '-sample-' num2str(index)],'SENSOR_DATA_MATRIX');
% SENSOR_CELL_INDEX is a container. struct('sensorID',[],'cellIndexNet',[],'cellIndexLink',[])
save([simu_evolutionDataFolder '\SENSOR_CELL_INDEX-CONFIG-' num2str(configID)],'SENSOR_CELL_INDEX');
% % all links density results
% save([evolutionDataFolder 'LINK-CONFIG-' num2str(configID) '-sample-' num2str(index)],'LINK');
% sensor data

saveSensorData2Mat_error(SENSOR_DATA_MATRIX, CONFIG, PARAMETER, index, simu_evolutionDataFolder);
% % boundary flows
% save([sampleDataFolder 'BOUNDARY_FLOWS'],'boundaryFlows');