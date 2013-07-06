function[measLoader] = initializeMeasurementLoader(rawDataFolder,networkId,configId)

measLoader = MeasurementLoader(rawDataFolder,networkId,configId);
numberOfLoadedSensors = measLoader.getNumberOfSensors();
% this doesn't mean that every sensor has data
disp(['number of sensors loaded ' num2str(numberOfLoadedSensors) ])