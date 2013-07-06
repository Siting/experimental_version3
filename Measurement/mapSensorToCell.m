function[SENSOR_CELL_INDEX] = mapSensorToCell(LINK_WITH_SENSOR,LINK,sensorMetaDataMap)


% creat SENSOR_CELL_INDEX
SENSOR_CELL_INDEX = containers.Map( 'KeyType', 'int64', 'ValueType', 'any');
sensor_cell_index = struct('sensorID',[],'cellIndexNet',[],'cellIndexLink',[]);

sensorIndex = [];

linkID = LINK_WITH_SENSOR.keys;


for i = 1 : length(linkID)
    link = LINK_WITH_SENSOR(linkID{i});
    for ii = 1:length(link.sensorID)
        sensor_cell_index.sensorID = link.sensorID(ii);

        sensorOffsetOnLink = sensorMetaDataMap(link.sensorID(ii)).offsetMiles;

        sensor_cell_index.cellIndexNet = LINK(linkID{i}).cellIndex(1) + ...
            ceil(sensorOffsetOnLink/LINK(linkID{i}).deltaX) - 1;

        sensor_cell_index.cellIndexLink = ceil(sensorOffsetOnLink/LINK(linkID{i}).deltaX);

        SENSOR_CELL_INDEX(sensor_cell_index.sensorID) = sensor_cell_index;
    end
end   