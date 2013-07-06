function[node] = setJunctionType(node,LINK)

% diverge?
if node.numIncomingLinks == 1 && node.numOutgoingLinks == 2
    % # incoimg lanes == # outgoing lanes?
    if LINK(node.incomingLink_1_ID).numLanes == ...
            LINK(node.outgoingLink_1_ID).numLanes + LINK(node.outgoingLink_2_ID).numLanes
        node.junctionType = 'diverge equal';
    % # incoming lanes < # outgoing lanes
    elseif LINK(node.incomingLink_1_ID).numLanes < ...
            LINK(node.outgoingLink_1_ID).numLanes + LINK(node.outgoingLink_2_ID).numLanes
        node.junctionType = 'diverge less';
        node.solverName = 'diverge';
    end
% merge?
elseif node.numIncomingLinks == 2 && node.numOutgoingLinks == 1
    % # incoimg lanes == # outgoing lanes?
    if LINK(node.incomingLink_1_ID).numLanes + LINK(node.incomingLink_2_ID).numLanes == ...
            LINK(node.outgoingLink_1_ID).numLanes
        node.junctionType = 'merge equal';
    % # incoming lanes > # outgoing lanes
    elseif LINK(node.incomingLink_1_ID).numLanes + LINK(node.incomingLink_2_ID).numLanes > ...
            LINK(node.outgoingLink_1_ID).numLanes
        node.junctionType = 'merge more';
        node.solverName = 'merge';
    end
% source?
elseif node.incomingLinks == -1
    node.junctionType='source';
    node.solverName = 'oneToOne';
% sink?
elseif node.outgoingLinks  == -1
    node.junctionType='sink';
    node.solverName = 'oneToOne';
end
