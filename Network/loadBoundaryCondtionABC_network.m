function[SOURCE_LINK, SINK_LINK] = loadBoundaryCondtionABC_network(SOURCE_LINK, SINK_LINK, T, startTime, endTime)

global boundarySourceSensorIDs
global boundarySinkSensorIDs
global sensorDataSource

% sourceLinkIds = SOURCE_LINK.keys;
% sinkLinkIds = SINK_LINK.keys;

if sensorDataSource == 2
% source
for i = 1 : length(SOURCE_LINK)
    source_link = SOURCE_LINK(i);
    load(['.\SensorData_feedIn\' num2str(boundarySourceSensorIDs(i)) '.mat']);

    % load data from startTime to endTime
    startCell = ceil((startTime*60)/T + 1);
    endCell = floor((endTime*60)/T + 1);
    flowDataSum = flowDataSum(startCell:endCell,1);
    
    source_link.densityResult = flowDataSum;
    
    SOURCE_LINK(i) = source_link;
end

% sink
for i = 1 : length(SINK_LINK)
    sink_link = SINK_LINK(i);
    load(['.\SensorData_feedIn\' num2str(boundarySinkSensorIDs(i)) '.mat']);
    
    % load data from startTime to endTime
    startCell = ceil((startTime*60)/T + 1);
    endCell = floor((endTime*60)/T + 1);
    flowDataSum = flowDataSum(startCell:endCell,1);
    
    sink_link.densityResult = flowDataSum;
    SINK_LINK(i) = sink_link;
end
else
    % read file
    fileName = (['.\Configurations\boundary_condition\BOUNDARY_CONDITION_CONFIG-' num2str(41) '.csv']);
    fid = fopen(fileName);
    disp(['opening file: ' fileName]);
    boundaryConditionData = textscan(fid,'%d %f %f %d %f %f','delimiter',',','headerlines',1);
    fclose(fid);
    % get boundary condition value
    sourceLinkIDs = [];
    sourceBoundaryValueMean = [];
    sourceBoundaryValueVar = [];
    sinkLinkIDs = [];
    sinkBoundaryValueMean = [];
    sinkBoundaryValueVar = [];
    % source
    for i = 1 : length(SOURCE_LINK)
        numLanes = SOURCE_LINK(i).numLanes;
        sourceLinkIDs = [sourceLinkIDs boundaryConditionData{1}(i)];
        sourceBoundaryValueMean = [sourceBoundaryValueMean boundaryConditionData{2}(i)];
        sourceBoundaryValueVar =  [sourceBoundaryValueVar boundaryConditionData{3}(i)];
    end
    % sink
    for i = 1 : length(SINK_LINK)
        sinkLinkIDs = [sinkLinkIDs boundaryConditionData{4}(i)];
        sinkBoundaryValueMean = [sinkBoundaryValueMean boundaryConditionData{5}(i)];
        sinkBoundaryValueVar = [sinkBoundaryValueVar boundaryConditionData{6}(i)];
    end
    
    % check if all link has been signed value in the csv file
    if size(sourceBoundaryValueMean,2) == length(SOURCE_LINK) &&...
 size(sinkBoundaryValueMean,2) == length(SINK_LINK)
numIntervals = 5;
        % source
        for i = 1 : length(SOURCE_LINK)
            source_link = SOURCE_LINK(i);
            varV = sourceBoundaryValueVar(i);
            meanV = sourceBoundaryValueMean(i);
            bValue = meanV + sqrt(varV) * randn(numIntervals,1);
            source_link.densityResult(1,1:numIntervals) = bValue;
            SOURCE_LINK(i) = source_link;
        end
        % sink
        for i = 1:length(SINK_LINK)
            sink_link = SINK_LINK(i);
            varV = sinkBoundaryValueVar(i);
            meanV = sinkBoundaryValueMean(i);
            bValue = meanV + sqrt(varV) * randn(numIntervals,1);
            sink_link.densityResult(1,1:numIntervals) = bValue;
            SINK_LINK(i) = sink_link;
        end
    else
        error('Number of links not equal to number of assigned values');
    end
    
end


