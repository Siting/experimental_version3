function[] = saveTestingCells(LINK, SENSOR_CELL_INDEX, PARAMETER, configID)

% extract sensor location (cell index)
sensorIDs = SENSOR_CELL_INDEX.keys;
sensorCellL = SENSOR_CELL_INDEX(sensorIDs{1}).cellIndexLink;
sensorCellR = SENSOR_CELL_INDEX(sensorIDs{2}).cellIndexLink;

% SOURCE (extract cell to its right)
sensorL = LINK(1).densityResult(sensorCellL,:,:);
firstCell = LINK(1).densityResult(sensorCellL + 1,:,:);

% SINK (extract cell to its left)
sensorR = LINK(1).densityResult(sensorCellR,:,:);
lastCell = LINK(1).densityResult(sensorCellR - 1,:,:);

% reshape
sensorL = reshape(sensorL, size(sensorL,3), 1);
firstCell = reshape(firstCell, size(firstCell,3), 1);
sensorR = reshape(sensorR, size(sensorR,3), 1);
lastCell = reshape(lastCell, size(lastCell,3), 1);

% add noise
if PARAMETER.trueStateErrorVar ~= 0
    sensorL = sensorL + sqrt(PARAMETER.trueStateErrorVar).*randn(size(sensorL,1),1);
    sensorR = sensorR + sqrt(PARAMETER.trueStateErrorVar).*randn(size(sensorR,1),1);
    firstCell = firstCell + sqrt(PARAMETER.trueStateErrorVar).*randn(size(firstCell,1),1);
    lastCell = lastCell + sqrt(PARAMETER.trueStateErrorVar).*randn(size(lastCell,1),1);
end


% save as mat file
if PARAMETER.trueStateErrorVar == 0   % no noise
    save(['.\Result\testingData\config-' num2str(configID) '\' num2str(sensorIDs{1}) '-true'], 'sensorL');
    save(['.\Result\testingData\config-' num2str(configID) '\' num2str(sensorIDs{2}) '-true'], 'sensorR');
    save(['.\Result\testingData\config-' num2str(configID) '\firstCell-true'], 'firstCell');
    save(['.\Result\testingData\config-' num2str(configID) '\lastCell-true'], 'lastCell');
else   % with noise
    save(['.\Result\testingData\config-' num2str(configID) '\' num2str(sensorIDs{1}) '-noisy'], 'sensorL');
    save(['.\Result\testingData\config-' num2str(configID) '\' num2str(sensorIDs{2}) '-noisy'], 'sensorR');
    save(['.\Result\testingData\config-' num2str(configID) '\firstCell-noisy'], 'firstCell');
    save(['.\Result\testingData\config-' num2str(configID) '\lastCell-noisy'], 'lastCell');
end