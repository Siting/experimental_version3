function[LINK] = oneToOneNew(sourceFeed,sinkFeed,node, LINK,page,ensemble,junctionSolverType, SOURCE_LINK,SINK_LINK)

% source?
if strcmp(num2str(node.junctionType),'source')
   [LINK] = updateSourceBoundaryFlux(node, sourceFeed,SOURCE_LINK,LINK,page,ensemble);
%    result=qSource;


% sink?
elseif strcmp(num2str(node.junctionType),'sink')
   [LINK] = updateSinkBoundaryFlux(node, sinkFeed,SINK_LINK,LINK,page,ensemble);
%    result=qSink;


% in the network?
else 
    leftDensity = LINK(node.incomingLink_1_ID).densityResult(end,ensemble,page-1);
    rightDensity = LINK(node.outgoingLink_1_ID).densityResult(1,ensemble,page-1);
    
    result = RS(leftDensity,LINK(node.incomingLink_1_ID).vmax,...
    LINK(node.incomingLink_1_ID).dmax,...
    LINK(node.incomingLink_1_ID).dc,rightDensity,...
    LINK(node.outgoingLink_1_ID).vmax,...
    LINK(node.outgoingLink_1_ID).dmax,...
    LINK(node.outgoingLink_1_ID).dc);
    
i = 1;
link(i) = LINK(node.incomingLink_1_ID);
link(i+1) = LINK(node.outgoingLink_1_ID);

link(i).rightFlux = result;
link(i+1).leftFlux = result;

LINK(node.incomingLink_1_ID) = link(i);
LINK(node.outgoingLink_1_ID) = link(i+1);
    
end

