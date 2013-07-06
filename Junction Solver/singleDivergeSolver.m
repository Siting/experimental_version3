% single lane diverge junction solver
function[result]=singleDivergeSolver(node, LINK,page,ensemble)

% extract links
inLink = LINK(node.incomingLink_1_ID);
outLink1 = LINK(node.outgoingLink_1_ID);
outLink2 = LINK(node.outgoingLink_2_ID);

% for diverge function
leftDensity = inLink.densityResult(end,ensemble,page-1);
rightDensity1 = outLink1.densityResult(1,ensemble,page-1);
rightDensity2 = outLink2.densityResult(1,ensemble,page-1);

% compute flux
% incoming link numbered 1, outgoing links numbered 2 and 3
splitRatio=node.ratio;
% bounding by sending of link 1
q1 = sending(leftDensity,inLink.vmax,...
    inLink.dmax,...
    inLink.dc);
% bounding by receiving of link 2
q2 = receiving(rightDensity1,...
    outLink1.vmax,...
    outLink1.dmax,...
    outLink1.dc) / splitRatio ;
% bounding by receiving of link 3
q3 = receiving(rightDensity2,...
    outLink2.vmax,...
    outLink2.dmax,...
    outLink2.dc) / (1-splitRatio);

A=[q1 q2 q3];
q = min(A);

q12 = splitRatio*q;
q13 = (1-splitRatio)*q;

result = [q q12 q13]; 