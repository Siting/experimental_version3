function[LINK_WITH_SENSOR] = checkSensorExistence(LINK)

% linkID is the ID of those links who has sensor on it
% sensorID is the ID of the sensors who has data
% pair sensor with link

% creat LINK_WITH_SENSOR
LINK_WITH_SENSOR = containers.Map( 'KeyType', 'int64', 'ValueType', 'any');
link_with_sensor = struct('linkID',[],'sensorID',[]);

% linkIds = LINK.keys;

for i = 1 : length(LINK)
    link = LINK(i);
    % link has sensor?
    if isempty(link.sensors) == 0
        link_with_sensor.linkID = i;
        link_with_sensor.sensorID = link.sensors;
        LINK_WITH_SENSOR(i) = link_with_sensor;
    end
end       