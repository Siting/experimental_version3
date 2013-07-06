function[result] = mergeMore(node, LINK,page,ensemble)
% merge more junction solver
% resutl = [flow from link1 to link3, flow from  link2 to link3, flow
% across the junction]

inLink1 =  LINK(node.incomingLink_1_ID);
inLink2 = LINK(node.incomingLink_2_ID);
outLink = LINK(node.outgoingLink_1_ID);

% get densities
leftDensity1 = inLink1.densityResult(end,ensemble,page-1);
leftDensity2 = inLink2.densityResult(end,ensemble,page-1);
rightDensity = outLink.densityResult(1,ensemble,page-1);

mergeRatio = node.ratio;

% [q13oLaneRatio1 q13sLaneRatio1 q23sLaneRatio1 q23oLaneRatio1...
%     q13oLaneRatio2 q13sLaneRatio2 q23sLaneRatio2 q23oLaneRatio2] = ...
%     computeLaneRatioForMergeMore(JUNCTION,junction_index);
% load(['node-' num2str(junction_index) '-junctionLaneRatio.mat']);

q13oLaneRatio1 = node.q13oLaneRatio1;
q13sLaneRatio1 = node.q13sLaneRatio1;
q23sLaneRatio1 = node.q23sLaneRatio1;
q23oLaneRatio1 = node.q23oLaneRatio1;
q13oLaneRatio2 = node.q13oLaneRatio2;
q13sLaneRatio2 = node.q13sLaneRatio2;
q23oLaneRatio2 = node.q23oLaneRatio2;

%% flow sending from link 1 to link 3
% s1 = sending(leftDensity1,inLink1.vmax,...
%     inLink1.dmax,...
%     inLink1.dc);
s1 = (leftDensity1>=inLink1.dc).*(inLink1.vmax*inLink1.dc) + (leftDensity1<inLink1.dc).*...
    (inLink1.vmax*leftDensity1.*((0<leftDensity1).*(leftDensity1<=inLink1.dc))+...
        (inLink1.dc*inLink1.vmax)*(inLink1.dmax-leftDensity1)./(inLink1.dmax-inLink1.dc).*...
        ((inLink1.dmax>leftDensity1).*(leftDensity1>inLink1.dc))+...
        0.*(leftDensity1>=inLink1.dmax)+0.*(leftDensity1<=0));
% flow sending from link 1 to link 3 (only)
s13o = q13oLaneRatio1 * s1;
% flow sending from link 1 to link 3 (share lane)
s13s = q13sLaneRatio1 * s1;

%% flow sending from link 2 to link 3
% s2 = sending(leftDensity2,inLink2.vmax,...
%     inLink2.dmax,...
%     inLink2.dc);
s2 = (leftDensity2>=inLink2.dc).*(inLink2.vmax*inLink2.dc) + (leftDensity2<inLink2.dc).*...
    (inLink2.vmax*leftDensity2.*((0<leftDensity2).*(leftDensity2<=inLink2.dc))+...
        (inLink2.dc*inLink2.vmax)*(inLink2.dmax-leftDensity2)./(inLink2.dmax-inLink2.dc).*((inLink2.dmax>leftDensity2).*(leftDensity2>inLink2.dc))+...
        0.*(leftDensity2>=inLink2.dmax)+0.*(leftDensity2<=0));
% flow sending from link 2 to link 3 (only)
s23o = q23oLaneRatio1 * s2;
% flow sending from link 2 to link 3 (share)
s23s = q23sLaneRatio1 * s2;

%% flow receiving by link 3
% r3 = receiving(rightDensity,outLink.vmax,...
%     outLink.dmax,...
%     outLink.dc);
r3 = (rightDensity >= outLink.dc) .* ( outLink.vmax*rightDensity.*((0<rightDensity).*(rightDensity<=outLink.dc))+...
        (outLink.dc*outLink.vmax)*(outLink.dmax-rightDensity)./(outLink.dmax-outLink.dc).*((outLink.dmax>rightDensity).*(rightDensity>outLink.dc))+...
        0.*(rightDensity>=outLink.dmax)+0.*(rightDensity<=0)) + (rightDensity < outLink.dc).*(outLink.vmax*outLink.dc);
% q13 is the flow comes from incoming link 1 to link 3
% q23 is the flow comes from incoming link 2 to link 3

%% flow going from link 1 to link 3 only
q13o = min(s13o, q13oLaneRatio2 * r3);
% flow going from link 2 to link 3 only
q23o = min(s23o, q23oLaneRatio2 * r3);

%% merging flow
% if s13s + s23s <= q13sLaneRatio2 * r3
%     q13s = s13s;
%     q23s = s23s;
%     qTotal = q13s + q23s;
% else
%     if s13s <= mergeRatio * q13sLaneRatio2 * r3
%         q13s = s13s;
%         q23s = q13sLaneRatio2 * r3 - q13s;
%     elseif s23s <= (1 - mergeRatio) * q13sLaneRatio2 * r3
%         q23s = s23s;
%         q13s = q13sLaneRatio2 * r3 - q23s;
%     else
%         q13s = mergeRatio * q13sLaneRatio2 * r3;
%         q23s = (1 - mergeRatio) * q13sLaneRatio2 * r3;
%     end
%     qTotal = q13sLaneRatio2 * r3;
% end

%% rewrite
q13s = (s13s + s23s <= q13sLaneRatio2 * r3).*s13s +...
    (s13s + s23s > q13sLaneRatio2 * r3).*(s13s <= mergeRatio * q13sLaneRatio2 * r3).*s13s+...
    (s13s + s23s > q13sLaneRatio2 * r3).*(s23s <= (1 - mergeRatio) * q13sLaneRatio2 * r3).*(q13sLaneRatio2 * r3 - s23s)+...
    (s13s + s23s > q13sLaneRatio2 * r3).*(s13s > mergeRatio * q13sLaneRatio2 * r3).*(s23s > (1 - mergeRatio) * q13sLaneRatio2 * r3).*(mergeRatio * q13sLaneRatio2 * r3);
q23s = (s13s + s23s <= q13sLaneRatio2 * r3).*s23s+...
    (s13s + s23s > q13sLaneRatio2 * r3).*(s13s <= mergeRatio * q13sLaneRatio2 * r3).*(q13sLaneRatio2 * r3 - s13s)+...
    (s13s + s23s > q13sLaneRatio2 * r3).*(s23s <= (1 - mergeRatio) * q13sLaneRatio2 * r3).*s23s+...
    (s13s + s23s > q13sLaneRatio2 * r3).*(s13s > mergeRatio * q13sLaneRatio2 * r3).*(s23s > (1 - mergeRatio) * q13sLaneRatio2 * r3).*((1 - mergeRatio) * q13sLaneRatio2 * r3);
% keyboard
%%
q13 = q13s + q13o;
q23 = q23s + q23o;
qTotal = q13 + q23;
result = [q13 q23 qTotal];
