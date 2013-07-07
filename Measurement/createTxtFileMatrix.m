function[SENSOR_DATA_MATRIX, SENSOR_CELL_INDEX, LINK_WITH_SENSOR] = createTxtFileMatrix(LINK,sensorMetaDataMap,numEns,...
    numTimeSteps,samplingInterval,startTime,unixTimeStep,trueStateErrorMean,trueStateErrorVar)

global testingSensorIDs

% This function generates 5 columns, the second column--dataString is
% planning to be generated later when writing txt file

% get the linkID of the link which has sensor on it
% LINK_WITH_SENSOR is a container. struct('linkID',[],'sensorID',[])
LINK_WITH_SENSOR = checkSensorExistence(LINK);

% map sensor to link
% SENSOR_CELL_INDEX is a container. struct('sensorID',[],'cellIndexNet',[],'cellIndexLink',[])
% sensorIndex is a vector of indicies of sensors for the whole network (
[SENSOR_CELL_INDEX] = mapSensorToCell(LINK_WITH_SENSOR,LINK,sensorMetaDataMap);

% store sensor data marix=================================================
% SENSOR_DATA_MATRIX is a comtainer
SENSOR_DATA_MATRIX = containers.Map('KeyType','int64','ValueType','any');
sensor_data_matrix = struct('sensorID',[],'matrix',[]);

numMeasurements = length(1 : samplingInterval : numTimeSteps);

% get Ids
sensorIds = SENSOR_CELL_INDEX.keys;
% linkIds = LINK.keys;

% first: iterate through links (li)
% second: if there is sensor, iterate through sensor on each link (s)
% third: when scanning sensors, iterate through time steps (t)
% fourth: when iterating time steps, iterate by ensemble (e)
% when iterating through ensembles, get mean first, then add errors
for li = 1 : length(LINK)
    link = LINK(li);
    % is there sensor on link? if yes...
    if any(li == (1:length(LINK)))
        
        for s = 1 : length(link.sensors)
            if any(link.sensors(s) == testingSensorIDs)
                % column content: 1.unixTime, 2.dateSting, 3.rawSpeedMph, 4.filteredSpeedMph
                % 5.volumeVph, 6.DENSITY (!!!!!!)   (OP has occupancy here)
                unixTime = [];
                dateString = zeros(numMeasurements,1);
                rawSpeedMph = [];
                filteredSpeedMph = [];
                volumeVph = [];
                density = [];
                % numTimeSteps+1 denotes the last page
                for t = 2 : samplingInterval : (numTimeSteps+1)
                    unixTime = [unixTime; startTime + (t-1)*unixTimeStep];
                    dateString = [];
                    % -1 is an arbitrary value
                    rawSpeedMph = [rawSpeedMph; -1];
                    filteredSpeedMph = [filteredSpeedMph; -1];
                    volumeVph = [volumeVph; -1];
                    d=0;
                    
                    for e = 1:numEns
                        d = d + link.densityResult(SENSOR_CELL_INDEX(link.sensors(s)).cellIndexLink,e,t);
                    end
                    error = trueStateErrorMean + sqrt(trueStateErrorVar).* randn(length(d));   % d is a scalar
                    density = [density; (d/numEns) + error];
                end
                
                sensor_data_matrix.sensorID = link.sensors(s);
                sensor_data_matrix.matrix = [unixTime dateString rawSpeedMph filteredSpeedMph volumeVph density];
                SENSOR_DATA_MATRIX(link.sensors(s)) = sensor_data_matrix;
            end
        end
    end
end