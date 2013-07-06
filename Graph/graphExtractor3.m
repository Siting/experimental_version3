% SENSOR, LINK, NODE
clear all
close all
networkId='CA-network-3';


%-------------------------------
%Extract sensor information here
%-------------------------------
%navteq_sensor_id,agency_sensor_id,hwy_link_id,offset_mi,navteq_link_id,navteq_cell_id,num_lanes_monitored,num_lanes_physical
fid = fopen(['sensorMetaData-' networkId '.csv']);
sensorMetaData = textscan(fid, '%d64 %d64 %d64 %f64 %d64 %d64 %d64 %d64','delimiter',',','headerlines',1);
fclose(fid);
sensorMetaDataMap=containers.Map('KeyType','int64','ValueType','any');
linkIdToSensorsMap=containers.Map('KeyType','int64','ValueType','any');
numberOfSensors=size(sensorMetaData{1},1);

for ii=1:numberOfSensors

    navteqSensorId=sensorMetaData{1}(ii);
    agencySensorId=sensorMetaData{2}(ii);
    hwyLinkId=sensorMetaData{3}(ii);
    offsetMiles=sensorMetaData{4}(ii);
    navteqLinkId=sensorMetaData{5}(ii);
    navteqCellId=sensorMetaData{6}(ii);
    numLanesMonitored=sensorMetaData{7}(ii);
    numLanesPhysical=sensorMetaData{8}(ii);
    
    if (linkIdToSensorsMap.isKey(hwyLinkId))
        sensorIds=linkIdToSensorsMap(hwyLinkId);
        sensorIds(end+1)=navteqSensorId;
        linkIdToSensorsMap(hwyLinkId)=sensorIds;
    else
        linkIdToSensorsMap(hwyLinkId)=navteqSensorId;
    end
    
    sensor=struct('navteqSensorId',navteqSensorId,'agencySensorId',agencySensorId,...
        'hwyLinkId',hwyLinkId,'offsetMiles',offsetMiles,'navteqLinkId',navteqLinkId,'navteqCellId',navteqCellId,...
        'numLanesMonitored',numLanesMonitored,'numLanesPhysical',numLanesPhysical);
    sensorMetaDataMap(navteqSensorId)=sensor;
    
end

fid = fopen(['linkToNode-' networkId '.csv']);
%link_id,length_miles,num_lanes,spd_lim_mph,in_node_id,in_node_lat,in_node_lon,out_node_id,out_node_lat,out_node_lon
linkToNodeData = textscan(fid, '%d64 %f64 %f %f %d64 %f %f %d64 %f %f','delimiter',',','headerlines',1);
fclose(fid);

%this map will contain link-->node
%node is a struct with incoming and outgoing fields
linkMap = containers.Map( ...
   'KeyType', 'int64', 'ValueType', 'any');

numberOfLinks=size(linkToNodeData{1},1);

for ii=1:numberOfLinks
    linkId=linkToNodeData{1}(ii);
    lengthInMiles=linkToNodeData{2}(ii);
    numLanes=linkToNodeData{3}(ii);
    spdLimInMph=linkToNodeData{4}(ii);
    inNode=linkToNodeData{5}(ii);
    startLatLon=[linkToNodeData{6}(ii) linkToNodeData{7}(ii)];
    outNode=linkToNodeData{8}(ii);
    endLatLon=[linkToNodeData{9}(ii) linkToNodeData{10}(ii)];
    
    sensorIds=[];
    if(linkIdToSensorsMap.isKey(linkId))
        sensorIds=linkIdToSensorsMap(linkId);
    end
    
    link = struct('linkId',linkId,'incomingNode',inNode,'outgoingNode',outNode,'numberOfLanes',numLanes,'spdLimInMph',spdLimInMph,'lengthInMiles',lengthInMiles,...
        'startLatLon',startLatLon,'endLatLon',endLatLon,'sensors',sensorIds);
    linkMap(linkId)=link;
end

%--------------
%now parse sinks
%------------
fid = fopen(['nodeToSinks-' networkId '.csv']);
%node_id,sink_ids,sink_lanes
%sink_ids and sink_lanes are given in {1,2,3} form
nodeToSinkData = textscan(fid, '%d64 %s %s','delimiter',',','headerlines',1);
fclose(fid);
nodeToSinkMap=containers.Map('KeyType','int64','ValueType','any');
%sinkPropertiesMap=containers.Map('KeyType','int64','ValueType','any');
numberOfSinks=size(nodeToSinkData{1},1);
for ii=1:numberOfSinks
    nodeId=nodeToSinkData{1}(ii);
    sinkIds=nodeToSinkData{2}(ii);
    sinkIds=sinkIds{1};
    %remove brackets
    sinkIds(1)=[];
    sinkIds(end)=[];
    sinkIds=int64(strread(sinkIds,'%d','delimiter',';'));

    if (sinkIds==-1)
        continue
    end
    sinkLanes=nodeToSinkData{3}(ii);
    sinkLanes=sinkLanes{1};
    sinkLanes(1)=[];
    sinkLanes(end)=[];
    sinkLanes=strread(sinkLanes,'%d','delimiter',';');
    
    sinks=cell(length(sinkIds),1);
    for id=1:length(sinkIds)
        sinks{id}=struct('sinkIds',sinkIds,'numberOfLanes',sinkLanes);
    end
    nodeToSinkMap(nodeId)=sinks;
end

%------
%parse sources

fid = fopen(['nodeToSources-' networkId '.csv']);
%node_id,sink_ids,sink_lanes
%sink_ids and sink_lanes are given in {1,2,3} form
nodeToSourceData = textscan(fid, '%d64 %s %s','delimiter',',','headerlines',1);
fclose(fid);
nodeToSourceMap=containers.Map('KeyType','int64','ValueType','any');
%sinkPropertiesMap=containers.Map('KeyType','int64','ValueType','any');
numberOfSources=size(nodeToSourceData{1},1);
for ii=1:numberOfSources
    nodeId=nodeToSourceData{1}(ii);
    sourceIds=nodeToSourceData{2}(ii);
    sourceIds=sourceIds{1};
    %remove brackets
    sourceIds(1)=[];
    sourceIds(end)=[];
    sourceIds=int64(strread(sourceIds,'%d','delimiter',';'));

    if (sourceIds==-1)
        continue
    end
    sourceLanes=nodeToSourceData{3}(ii);
    sourceLanes=sourceLanes{1};
    sourceLanes(1)=[];
    sourceLanes(end)=[];
    sourceLanes=strread(sourceLanes,'%d','delimiter',';');
    
    sources=cell(length(sourceIds),1);
    for id=1:length(sourceIds)
        sources{id}=struct('sourceIds',sourceIds,'numberOfLanes',sourceLanes);
    end
    nodeToSourceMap(nodeId)=sources;
end
%------------
%finally parse nodes
%


fid = fopen(['nodeToLinks-' networkId '.csv']);
%node_id,out_link_ids,in_link_ids
%link_ids are given in {1,2,3} form
nodeToLinkData = textscan(fid, '%d64 %s %s','delimiter',',','headerlines',1);
fclose(fid);
nodeMap=containers.Map('KeyType','int64','ValueType','any');
%parse nodes
numberOfNodes=size(nodeToLinkData{1},1);
for ii=1:numberOfNodes
    nodeId=nodeToLinkData{1}(ii);
    outgoingLinks=nodeToLinkData{2}(ii);
    outgoingLinks=outgoingLinks{1};
    %remove curly brackets
    outgoingLinks(1)=[];
    outgoingLinks(end)=[];
    outgoingLinks=int64(strread(outgoingLinks,'%d','delimiter',';'));
    incomingLinks=nodeToLinkData{3}(ii);
    incomingLinks=incomingLinks{1};
    incomingLinks(1)=[];
    incomingLinks(end)=[];    
    incomingLinks=int64(strread(incomingLinks,'%d','delimiter',';'));
    sinks=[];
    if (nodeToSinkMap.isKey(nodeId))
        sinks=nodeToSinkMap(nodeId);
    end
    sources=[];    
    if (nodeToSourceMap.isKey(nodeId))
        sources=nodeToSourceMap(nodeId);
    end
    
    node=struct('nodeId',nodeId,'outgoingLinks',outgoingLinks,'incomingLinks',incomingLinks,'sinks',sinks,'sources',sources);
    nodeMap(nodeId)=node;
end


disp('checking nodes')
nodeIds=nodeMap.keys;
for ii=1:length(nodeIds)
    nodeId=nodeIds{ii};
    node=nodeMap(nodeId);
    outgoingLinks=node.outgoingLinks;
    incomingLinks=node.incomingLinks;
    sinks=node.sinks;
    sources=node.sources;
    
    if (isempty(outgoingLinks) && isempty(sinks))
            disp(['warning, check node ' nodeId]);
    end
    
    if (isempty(incomingLinks) && isempty(sources))
            disp(['warning, check node ' nodeId]);
    end
    
end
disp('node checks finished')

save(['.\Graph\' networkId '-graph'],'nodeMap','linkMap','sensorMetaDataMap') 

