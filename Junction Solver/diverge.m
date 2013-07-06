function[LINK] = diverge(node, LINK,page,ensemble,junctionSolverType)

% Pick which diverge model to use

if strcmp(junctionSolverType,'multi-lane model')
    % diverge less
    if strcmp(node.junctionType,'diverge less')
        result=divergeLess(node, LINK,page,ensemble);
        % diverge equal?
    elseif strcmp(node.junctionType,'diverge equal')
        result=divergeEqual(node,LINK,page,ensemble);        
    else
        disp('The diverge junction is not falling into any of the two categories');
    end

elseif strcmp(junctionSolverType,'single lane model')
    result=singleDivergeSolver(node, LINK,page,ensemble);

else
    error('There is a problem picking junction solver');
end


% link(1)=LINK(node.incomingLink_1_ID);
% link(2)=LINK(node.outgoingLink_1_ID);
% link(3)=LINK(node.outgoingLink_2_ID);
% 
% link(1).rightFlux=result(1);
% link(2).leftFlux=result(2);
% link(3).leftFlux=result(3);
% 
% LINK(node.incomingLink_1_ID)=link(1);
% LINK(node.outgoingLink_1_ID)=link(2);
% LINK(node.outgoingLink_2_ID)=link(3);

LINK(node.incomingLink_1_ID).rightFlux = result(1);
LINK(node.outgoingLink_1_ID).leftFlux = result(2);
LINK(node.outgoingLink_2_ID).leftFlux = result(3);



