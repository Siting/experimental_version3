function[result] = divergeEqual(node, LINK,page,ensemble)  
% diverge equal junction solver
% reuslt = [flow across the junction, flow from link1 to link3, flow from
% link1 to link4]

% extract links
inLink1 = LINK(node.incomingLink_1_ID);
outLink1 = LINK(node.outgoingLink_1_ID);
outLink2 = LINK(node.outgoingLink_2_ID);

% get densities
leftDensity = inLink1.densityResult(end,ensemble,page-1);
rightDensity1 = outLink1.densityResult(1,ensemble,page-1);
rightDensity2 = outLink2.densityResult(1,ensemble,page-1);

% number of lanes going from link 1 to link 3
num12 = outLink1.numLanes;
% number of lanes going from link 1 to link 4
num13 = outLink2.numLanes;

% compute split ratio which is based on lane ratio
splitRatio = num12 / (num12 + num13);

% bounding by ratio of flow sending by link 1
q1 = splitRatio * sending(leftDensity,inLink1.vmax,...
    inLink1.dmax,...
    inLink1.dc);
% bounding by (1-ratio) of flow sending by link 1
q2 = (1-splitRatio) * sending(leftDensity,inLink1.vmax,...
    inLink1.dmax,...
    inLink1.dc);
% bounding by receiving of link 3
q3 = receiving(rightDensity1,outLink1.vmax,...
    outLink1.dmax,...
    outLink1.dc);
% bounding by receiving of link 4
q4 = receiving(rightDensity2,outLink2.vmax,...
    outLink2.dmax,...
    outLink2.dc);
% get the min(sending, receiving)
A = [q1 q3];
B = [q2 q4];
% compute flows
q13 = min(A);
q14 = min(B);
q1 = q13 + q14;

result=[q1 q13 q14];