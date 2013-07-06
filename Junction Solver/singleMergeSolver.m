function[result] = singleMergeSolver(node, LINK,page,ensemble)

% extract links
inLink1 = LINK(node.incomingLink_1_ID);
inLink2 = LINK(node.incomingLink_2_ID);
outLink = LINK(node.outgoingLink_1_ID);

% get densities
leftDensity1 = inLink1.densityResult(end,ensemble,page-1);
leftDensity2 = inLink2.densityResult(end,ensemble,page-1);
rightDensity = outLink.densityResult(1,ensemble,page-1);

mergeRatio = node.mergeLaneRatio;

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

% sending < = receiving
if (s1 + s2) <= r3
    q13 = s1;
    q23 = s2;
    qTotal = q13 + q23;
% sending > receiving
else
    if s1 <= mergeRatio * r3
        q13 = s1;
        q23 = r3 - q13;
    elseif s2 <= (1 - mergeRatio) * r3
        q23 = s2;
        q13 = r3 - q23;
    else 
        q13 = mergeRatio * r3;
        q23 = (1 - mergeRatio) * r3;
    end
    qTotal = r3;
end

result = [q13 q23 qTotal];
