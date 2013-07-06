function[LINK] = updateSourceBoundaryFlux(node, sourceFeed,SOURCE_LINK,LINK,page,ensemble)

link = LINK(node.outgoingLink_1_ID);
sourceLink = SOURCE_LINK(node.incomingLink_1_ID);

qSource(node.outgoingLink_1_ID) = RS(sourceFeed(node.outgoingLink_1_ID),...
    sourceLink.vmax,sourceLink.dmax,...
    sourceLink.dc,...
        link.densityResult(1,ensemble,page-1),link.vmax,link.dmax,link.dc);

link.leftFlux = qSource(node.outgoingLink_1_ID);

LINK(node.outgoingLink_1_ID) = link;