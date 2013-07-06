function [sensorDataMap]=sensorDataSerializer(rawDataFolder,networkId)
%right now this assumes that every sensor has a file that
%contains at least the header line
%Error handling will be added later
%rawDataFolder='./raw_measurement_data/';
% networkId='NA-USA-CALIFORNIA';
load([networkId '-graph.mat']);

mappedSensorIds=sensorMetaDataMap.keys;
numberOfSensors=size(mappedSensorIds,2);
disp(['measurements will be loaded for ' num2str(numberOfSensors) ' sensors'])
%this is the big map that has the sensor Id as a key:
sensorDataMap=containers.Map('KeyType','double','ValueType','any');

for sensor=1:numberOfSensors
    %unix_time,time_gmt,raw_speed_mph,filtered_speed_mph,volume_vph,occupancy
    sensorId = mappedSensorIds{sensor};
    fileName=[rawDataFolder networkId '-' num2str(sensorId) '.txt'];
    fid = fopen(fileName);
    disp(['opening file: ' fileName])
    sensorData = textscan(fid, '%f %s %f %f %f %f','delimiter',',','headerlines',1);
    fclose(fid);
    
    
    %for each sensor we create a map of measurements that has
    %the time as key
    
    singleSensorDataMap=containers.Map('KeyType','double','ValueType','any');
    
    numberOfMeasurements = size(sensorData{1},1);
    %loop every measurement for this sensor
    for measurement=1:numberOfMeasurements
        
        
        unixTime = sensorData{1}(measurement);
        dateString=sensorData{2}(measurement);
        rawSpeedMph=sensorData{3}(measurement);
        filteredSpeedMph=sensorData{4}(measurement);
        volumeVph=sensorData{5}(measurement);
        occupancy=sensorData{6}(measurement);
        
        measurement=struct('unixTime',unixTime,'dateString',dateString,...
            'rawSpeedMph',rawSpeedMph,'filteredSpeedMph',filteredSpeedMph,'volumeVph',volumeVph,...
            'occupancy',occupancy);
        
        singleSensorDataMap(unixTime)=measurement;
       
        
    end
    
    %add singleSensorMap to big map
    sensorDataMap(sensorId)=singleSensorDataMap;
    disp(['added data for sensor ' num2str(sensorId)])
end

%save([networkId '-measurements'],'sensorDataMap') 