function[JUNCTION] = preloadJunctions(nodeMap, LINK)

% JUNCTION = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');

nodeIds = nodeMap.keys;

for i = length(nodeIds) : -1 : 1
    NTnode = nodeMap(nodeIds{i});
    NODE(i) = struct('nodeId',NTnode.nodeId,'outgoingLinks',NTnode.outgoingLinks,...
        'incomingLinks',NTnode.incomingLinks,'sinks',NTnode.sinks,'sources',NTnode.sources,...
        'numIncomingLinks',length(NTnode.incomingLinks),...
        'numOutgoingLinks',length(NTnode.outgoingLinks),'incomingLink_1_ID',[],'incomingLink_2_ID',[],...
        'outgoingLink_1_ID',[],'outgoingLink_2_ID',[],'num_JunctionA',[],'num_JunctionB',[],...
        'num_JunctionC',[],'ratio',[],'junctionType',[],'splitLaneRatio',[],'mergeLaneRatio',[],...
        'q13oLaneRatio1',[],'q13sLaneRatio1',[],'q23sLaneRatio1',[],...
        'q23oLaneRatio1',[],'q13oLaneRatio2',[],'q13sLaneRatio2',[],'q23sLaneRatio2',[],'q23oLaneRatio2',[],...
        'q14sLaneRatio1',[],'q14oLaneRatio1',[],'q14sLaneRatio2',[], 'q14oLaneRatio2', [], 'solverName', []);
    
    % set incomingLink_ID for incoming links  (up to 2 incoming links)
    NODE(i) = setIncomingLinksID(NODE(i),NTnode);

    % set outgoingLink_ID for outgoing links  (up to 2 outgoing links)
    NODE(i) = setOutgoingLinksID(NODE(i),NTnode);
    
    % set juction type
    NODE(i) = setJunctionType(NODE(i),LINK);

    % set numLanes for section A/B/C
    if strcmp(NODE(i).junctionType,'diverge less')
        NODE(i).num_JunctionA = LINK(NODE(i).outgoingLink_1_ID).numLanes - 1;
        NODE(i).num_JunctionB = 1;        % # of sharing lane is always 1
        NODE(i).num_JunctionC = LINK(NODE(i).outgoingLink_2_ID).numLanes - 1;
    elseif strcmp(NODE(i).junctionType,'diverge equal')
        NODE(i).num_JunctionA = LINK(NODE(i).outgoingLink_1_ID).numLanes - 1;
        NODE(i).num_JunctionB = 1;        % # of sharing lane is always 1
        NODE(i).num_JunctionC = LINK(NODE(i).outgoingLink_2_ID).numLanes - 1;  
        
    elseif strcmp(NODE(i).junctionType,'merge more')          % # incoming lanes more than # outgoing lanes
        if LINK(NODE(i).incomingLink_1_ID).numLanes == 1
            NODE(i).num_JunctionA = 0;
            NODE(i).num_JunctionB = 1;
            NODE(i).num_JunctionC = LINK(NODE(i).outgoingLink_1_ID).numLanes - 1;
        else
            NODE(i).num_JunctionB = 1;
            NODE(i).num_JunctionA = LINK(NODE(i).incomingLink_1_ID).numLanes - NODE(i).num_JunctionB;
            NODE(i).num_JunctionC = LINK(NODE(i).outgoingLink_1_ID).numLanes - (NODE(i).num_JunctionA+NODE(i).num_JunctionB);
        end
    elseif strcmp(NODE(i).junctionType,'merge equal')
        NODE(i).num_JunctionA = LINK(NODE(i).incomingLink_1_ID).numLanes;
        NODE(i).num_JunctionB = 0;
        NODE(i).num_JunctionC = LINK(NODE(i).incomingLink_2_ID).numLanes;
    end

    % compute lane ratio==============================
    if strcmp(NODE(i).junctionType,'merge more')
        [NODE(i).q13oLaneRatio1, NODE(i).q13sLaneRatio1, NODE(i).q23sLaneRatio1, NODE(i).q23oLaneRatio1,...
            NODE(i).q13oLaneRatio2, NODE(i).q13sLaneRatio2, NODE(i).q23sLaneRatio2, NODE(i).q23oLaneRatio2] = ...
            computeLaneRatioForMergeMore(NODE(i));
    elseif strcmp(NODE(i).junctionType,'diverge less')
        [NODE(i).q13oLaneRatio1, NODE(i).q13sLaneRatio1, NODE(i).q14sLaneRatio1, NODE(i).q14oLaneRatio1,...
            NODE(i).q13oLaneRatio2, NODE(i).q13sLaneRatio2, NODE(i).q14sLaneRatio2, NODE(i).q14oLaneRatio2]...
            = computeLaneRatioForDivergeLess(NODE(i));
    end
    % end============================================
    
    JUNCTION(i)=NODE(i);
end
