function[SOURCE_LINK SINK_LINK] = loadSourceSinkLinks(nodeMap,FUNDAMENTAL, LINK)

global funsOption

SOURCE_LINK = containers.Map( ...
    'KeyType', 'int64', 'ValueType', 'any');

SINK_LINK = containers.Map( ...
    'KeyType', 'int64', 'ValueType', 'any');


nodeIds = nodeMap.keys;
% 1st: check if it is source
% 2nd: check if it is sink
for i = 1 : length(nodeIds)
    node = nodeMap(nodeIds{i});
    if isempty(node.sources) == 0
        % this is a source (it's the left boundary node of the network)
        source_link = struct('linkID',[],'linkDesc',[],'numLanes',[],'vmax',[],'dmax',[],...
            'dc',[],'sensorID',[],'densityResult',[],'outgoingLinkID',[]);
        source_link.linkID = node.sources.sourceIds;
        source_link.linkDesc = 'source';
        
        if funsOption == 1
            source_link.vmax = FUNDAMENTAL.vmax;
            source_link.dc = node.sources.numberOfLanes * FUNDAMENTAL.dc;
            source_link.dmax = node.sources.numberOfLanes * FUNDAMENTAL.dmax;
        elseif funsOption == 2
            source_link.vmax = LINK(node.outgoingLinks).vmax;
            source_link.dmax = LINK(node.outgoingLinks).dmax;
            source_link.dc =  LINK(node.outgoingLinks).dc;
        end
        
        source_link.outgoingLinkID = node.outgoingLinks;
        %         source_link.numLanes = LINK(source_link.outgoingLinkID).numLanes;
        SOURCE_LINK(node.sources.sourceIds) = source_link;
    elseif isempty(node.sinks) == 0
        % this is a sink (it's the right boundary node of the network)
        sink_link = struct('linkID',[],'linkDesc',[],'numLanes',[],'vmax',[],'dmax',[],...
            'dc',[],'sensorID',[],'densityResult',[],'incomingLinkID',[]);
        sink_link.linkID = node.sinks.sinkIds;
        sink_link.linkDesc = 'sink';
        
        if funsOption == 1
            sink_link.vmax = FUNDAMENTAL.vmax;
            sink_link.dc = node.sinks.numberOfLanes * FUNDAMENTAL.dc;
            sink_link.dmax = node.sinks.numberOfLanes * FUNDAMENTAL.dmax;
        elseif funsOption == 2
            sink_link.vmax = LINK(node.incomingLinks).vmax;
            sink_link.dmax = LINK(node.incomingLinks).dmax;
            sink_link.dc =  LINK(node.incomingLinks).dc;
        end
        
        sink_link.incomingLinkID = node.incomingLinks;
%         sink_link.numLanes = LINK(sink_link.incomingLinkID).numLanes;
        SINK_LINK(node.sinks.sinkIds) = sink_link;
    end
end

