function[LINK] = merge(node, LINK,page,ensemble,junctionSolverType)

if strcmp(junctionSolverType,'multi-lane model')
    
    if strcmp(node.junctionType,'merge more')
        result = mergeMore(node, LINK,page,ensemble);
    elseif strcmp(node.junctionType,'merge equal')
        result = mergeEqual(node, LINK,page,ensemble);
    end

elseif strcmp(junctionSolverType,'single lane model')
    result = singleMergeSolver(node, LINK,page,ensemble);
else
    error('There is a problem picking junction solver');
    
end


% link(1)=LINK(node.incomingLink_1_ID);
% link(2)=LINK(node.incomingLink_2_ID);
% link(3)=LINK(node.outgoingLink_1_ID);

LINK(node.incomingLink_1_ID).rightFlux=result(1);
LINK(node.incomingLink_2_ID).rightFlux=result(2);
LINK(node.outgoingLink_1_ID).leftFlux=result(3);

% LINK(node.incomingLink_1_ID)=link(1);
% LINK(node.incomingLink_2_ID)=link(2);
% LINK(node.outgoingLink_1_ID)=link(3);
