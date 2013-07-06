function[] = writeTxtFile(SENSOR_DATA_MATRIX, dataFolder, trueStateErrorVar)

sensorIds = SENSOR_DATA_MATRIX.keys;

for i = 1 : length(sensorIds)
    sensorID = sensorIds{i};
    matrix = SENSOR_DATA_MATRIX(sensorID).matrix;
    % converte date string here
    dateString = cellstr(datestr(SENSOR_DATA_MATRIX(sensorID).matrix(:,1),'yyyy-mm-dd HH:MM:SS.FFF'));
    % add headline here
    if trueStateErrorVar == 0
        fid = fopen([dataFolder num2str(sensorID) '-true.txt'], 'w');
    else
        fid = fopen([dataFolder num2str(sensorID) '-noisy.txt'], 'w');
    end
    for line = 1 : (size(dateString,1)+1)
        if line == 1
            fprintf(fid, '%s,%s,%s,%s,%s,%s','unixTime', 'time_gmt', 'raw_speed_mph', 'filtered_speed_mph', 'volume_vph', 'density');
        else            
            fprintf(fid, '\n%f,%s,%f,%f,%f,%f', double(matrix(line-1,1)),dateString{line-1},matrix(line-1,2),matrix(line-1,3),...
                 matrix(line-1,4),matrix(line-1,5));
        end
    end
    fclose(fid);
end;