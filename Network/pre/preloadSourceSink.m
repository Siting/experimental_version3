function[SOURCE_LINK, SINK_LINK] = preloadSourceSink(nodeMap, T, startTime, endTime)

% This function: 1. load nodeMap to set up SOURCE_LINK, SINK_LINK 
%                   set FUNDAMENTAL parameters all 0 
%                2. load Boundary Condition

% SOURCE_LINK = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');
% 
% SINK_LINK = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');

nodeIds = nodeMap.keys;
% 1st: check if it is source
% 2nd: check if it is sink
for i = length(nodeIds) : -1 : 1
    node = nodeMap(nodeIds{i});
    if isempty(node.sources) == 0
        % this is a source (it's the left boundary node of the network)
        source_link(i) = struct('linkID',[],'linkDesc',[],'numLanes',[],'vmax',[],'dmax',[],...
            'dc',[],'sensorID',[],'densityResult',[],'outgoingLinkID',[]);
        source_link(i).linkID = node.sources.sourceIds;
        source_link(i).linkDesc = 'source';
        %=============================
        source_link(i).vmax = 0;
        source_link(i).dc = 0;
        source_link(i).dmax = 0;
        %=============================
        source_link(i).outgoingLinkID = node.outgoingLinks;
        SOURCE_LINK(node.sources.sourceIds) = source_link(i);
    elseif isempty(node.sinks) == 0
        % this is a sink (it's the right boundary node of the network)
        sink_link(i) = struct('linkID',[],'linkDesc',[],'numLanes',[],'vmax',[],'dmax',[],...
            'dc',[],'sensorID',[],'densityResult',[],'incomingLinkID',[]);
        sink_link(i).linkID = node.sinks.sinkIds;
        sink_link(i).linkDesc = 'sink';
        %============================
        sink_link(i).vmax = 0;
        sink_link(i).dc = 0;
        sink_link(i).dmax = 0;
        %============================
        sink_link(i).incomingLinkID = node.incomingLinks;
        SINK_LINK(node.sinks.sinkIds) = sink_link(i);
    end
end

[SOURCE_LINK, SINK_LINK] = loadBoundaryCondtionABC_network(SOURCE_LINK, SINK_LINK, T, startTime, endTime);

