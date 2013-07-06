function[result] = mergeEqual(node, LINK,page,ensemble)
% merge equal junction solver
% resutl = [flow from link1 to link3, flow from  link2 to link3, flow
% across the junction]

% extrat links
inLink1 = LINK(node.incomingLink_1_ID);
inLink2 = LINK(node.incomingLink_2_ID);
outLink = LINK(node.outgoingLink_1_ID);

% for merge junction
leftDensity1 = inLink1.densityResult(end,ensemble,page-1);
leftDensity2 = inLink2.densityResult(end,ensemble,page-1);
rightDensity = outLink.densityResult(1,ensemble,page-1);

% q13 is the flow comes from incoming link 1 to link 3
% q23 is the flow comes from incoming link 2 to link 3
mergeRatio = inLink1.numLanes/...
    outLink.numLanes;
% sending of link 1
s1 = sending(leftDensity1,inLink1.vmax,...
    inLink1.dmax,...
    inLink1.dc);
% sending of link 2
s2 = sending(leftDensity2,inLink2.vmax,...
    inLink2.dmax,...
    inLink2.dc);
% receiving of link 3 
r3 = receiving(rightDensity,outLink.vmax,...
    outLink.dmax,...
    outLink.dc);

% q13 is the flow comes from incoming link 1 to link 3
% q23 is the flow comes from incoming link 2 to link 3

q13 = min(s1, mergeRatio * r3);
q23 = min(s2, (1-mergeRatio) * r3);

qTotal = q13 + q23;

result = [q13 q23 qTotal];