function[JUNCTION] = loadJunctions(nodeMap,LINK)
JUNCTION = containers.Map( ...
    'KeyType', 'int64', 'ValueType', 'any');

nodeIds = nodeMap.keys;

for i = 1 : length(nodeIds)
    NTnode = nodeMap(nodeIds{i});
    node = struct('nodeId',NTnode.nodeId,'outgoingLinks',NTnode.outgoingLinks,...
        'incomingLinks',NTnode.incomingLinks,'sinks',NTnode.sinks,'sources',NTnode.sources,...
        'numIncomingLinks',length(NTnode.incomingLinks),...
        'numOutgoingLinks',length(NTnode.outgoingLinks),'incomingLink_1_ID',[],'incomingLink_2_ID',[],...
        'outgoingLink_1_ID',[],'outgoingLink_2_ID',[],'num_JunctionA',[],'num_JunctionB',[],...
        'num_JunctionC',[],'ratio',[],'junctionType',[],'splitLaneRatio',[],'mergeLaneRatio',[]);
    
    % set incomingLink_ID for incoming links  (up to 2 incoming links)
    node = setIncomingLinksID(node,NTnode);

    % set outgoingLink_ID for outgoing links  (up to 2 outgoing links)
    node = setOutgoingLinksID(node,NTnode);
    
    % set juction type
    node = setJunctionType(node,LINK);

    % set numLanes for section A/B/C
    if strcmp(node.junctionType,'diverge less')
        node.num_JunctionA = LINK(node.outgoingLink_1_ID).numLanes - 1;
        node.num_JunctionB = 1;        % # of sharing lane is always 1
        node.num_JunctionC = LINK(node.outgoingLink_2_ID).numLanes - 1;
    elseif strcmp(node.junctionType,'diverge equal')
        node.num_JunctionA = LINK(node.outgoingLink_1_ID).numLanes - 1;
        node.num_JunctionB = 1;        % # of sharing lane is always 1
        node.num_JunctionC = LINK(node.outgoingLink_2_ID).numLanes - 1;  
        
    elseif strcmp(node.junctionType,'merge more')          % # incoming lanes more than # outgoing lanes
        if LINK(node.incomingLink_1_ID).numLanes == 1
            node.num_JunctionA = 0;
            node.num_JunctionB = 1;
            node.num_JunctionC = LINK(node.outgoingLink_1_ID).numLanes - 1;
        else
            node.num_JunctionB = 1;
            node.num_JunctionA = LINK(node.incomingLink_1_ID).numLanes - node.num_JunctionB;
            node.num_JunctionC = LINK(node.outgoingLink_1_ID).numLanes - (node.num_JunctionA+node.num_JunctionB);
        end
    elseif strcmp(node.junctionType,'merge equal')
        node.num_JunctionA = LINK(node.incomingLink_1_ID).numLanes;
        node.num_JunctionB = 0;
        node.num_JunctionC = LINK(node.incomingLink_2_ID).numLanes;
    end
    
    JUNCTION(nodeIds{i})=node;
end