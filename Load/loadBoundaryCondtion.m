function[SOURCE_LINK, SINK_LINK] = loadBoundaryCondtion(SOURCE_LINK,SINK_LINK,numIntervals,CONFIG)

sourceLinkIds = SOURCE_LINK.keys;
sinkLinkIds = SINK_LINK.keys;
boundaryCondtionID = CONFIG.boundaryConditionID;


% if there is no file have the boundary condition assinged, then use arbitrary values 
% if there is file, use the value in the file
if isempty(boundaryCondtionID)
    disp('There is no boundary condition file, using arbitrary values.');
    % source
    for i = 1:length(sourceLinkIds)
        source_link = SOURCE_LINK(sourceLinkIds{i});        
        gamma = 5;
        meanV = source_link.numLanes * 10;
        bValue = meanV + sqrt(gamma) * randn(1);
        source_link.densityResult(1,1:numIntervals) = bValue;
        SOURCE_LINK(sourceLinkIds{i}) = source_link;
    end
    % sink
    for i = 1 : length(sinkLinkIds)
        sink_link = SINK_LINK(sinkLinkIds{i});
        gamma = 5;
        meanV = sink_link.numLanes * 10;
        bValue = meanV + sqrt(gamma) * randn(1);
        sink_link.densityResult(1,1:numIntervals) = bValue * ones(1,numIntervals);
        SINK_LINK(sinkLinkIds{i}) = sink_link;
    end
else
    % Process========================
    % read boundary condition file
    % store boundary condition values by sink and source categories
    % iterate through all sources and sinks, assign values
    % end=========================== 

    % read file
    fileName = (['.\Configurations\boundary_condition\BOUNDARY_CONDITION_CONFIG-' num2str(CONFIG.configID) '.csv']);
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
    for i = 1 : length(sourceLinkIds)
        numLanes = SOURCE_LINK(sourceLinkIds{i}).numLanes;
        sourceLinkIDs = [sourceLinkIDs boundaryConditionData{1}(i)];
        sourceBoundaryValueMean = [sourceBoundaryValueMean boundaryConditionData{2}(i)];
        sourceBoundaryValueVar =  [sourceBoundaryValueVar boundaryConditionData{3}(i)];
    end
    % sink
    for i = 1 : length(sinkLinkIds)
        sinkLinkIDs = [sinkLinkIDs boundaryConditionData{4}(i)];
        sinkBoundaryValueMean = [sinkBoundaryValueMean boundaryConditionData{5}(i)];
        sinkBoundaryValueVar = [sinkBoundaryValueVar boundaryConditionData{6}(i)];
    end
    
    % check if all link has been signed value in the csv file
    if size(sourceBoundaryValueMean,2) == length(sourceLinkIds) &&...
 size(sinkBoundaryValueMean,2) == length(sinkLinkIds)
        % source
        for i = 1 : length(sourceLinkIds)
            source_link = SOURCE_LINK(sourceLinkIds{i});
            varV = sourceBoundaryValueVar(i);
            meanV = sourceBoundaryValueMean(i);
            bValue = meanV + sqrt(varV) * randn(numIntervals,1);
            source_link.densityResult(1,1:numIntervals) = bValue;
            SOURCE_LINK(sourceLinkIds{i}) = source_link;
        end
        % sink
        for i = 1:length(sinkLinkIds)
            sink_link = SINK_LINK(sinkLinkIds{i});
            varV = sinkBoundaryValueVar(i);
            meanV = sinkBoundaryValueMean(i);
            bValue = meanV + sqrt(varV) * randn(numIntervals,1);
            sink_link.densityResult(1,1:numIntervals) = bValue;
            SINK_LINK(sinkLinkIds{i}) = sink_link;
        end
    else
        error('Number of links not equal to number of assigned values');
    end
end
