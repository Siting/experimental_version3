function[result] = divergeLess(node,LINK,page,ensemble)
% diverge less junction solver
% reuslt = [flow across the junction, flow from link1 to link3, flow from
% link1 to link4]

% extract links
inLink1 = LINK(node.incomingLink_1_ID);
outLink1 = LINK(node.outgoingLink_1_ID);
outLink2 = LINK(node.outgoingLink_2_ID);

% for diverge function
leftDensity = inLink1.densityResult(end,ensemble,page-1);
rightDensity1 = outLink1.densityResult(1,ensemble,page-1);
rightDensity2 = outLink2.densityResult(1,ensemble,page-1);

% compute lane ratio
% [q13oLaneRatio1 q13sLaneRatio1 q14sLaneRatio1 q14oLaneRatio1 q13oLaneRatio2 q13sLaneRatio2 q14sLaneRatio2 q14oLaneRatio2]...
%     = computeLaneRatioForDivergeLess(JUNCTION,junction_index);
% load(['node-' num2str(junction_index) '-junctionLaneRatio.mat']);
q13oLaneRatio1 = node.q13oLaneRatio1;
q13sLaneRatio1 = node.q13sLaneRatio1;
q14oLaneRatio1 = node.q14oLaneRatio1;
q13oLaneRatio2 = node.q13oLaneRatio2;
q13sLaneRatio2 = node.q13sLaneRatio2;
q14sLaneRatio2 = node.q14sLaneRatio2;
q14oLaneRatio2 = node.q14oLaneRatio2;

% splitRatio
splitRatio = node.ratio;

%% sending of link 1
% s1 = sending(leftDensity,inLink1.vmax,...
%     inLink1.dmax,...
%     inLink1.dc);
s1 = (leftDensity>=inLink1.dc).*(inLink1.vmax*inLink1.dc) + (leftDensity<inLink1.dc).*...
    (inLink1.vmax*leftDensity.*((0<leftDensity).*(leftDensity<=inLink1.dc))+...
        (inLink1.dc*inLink1.vmax)*(inLink1.dmax-leftDensity)./(inLink1.dmax-inLink1.dc).*...
        ((inLink1.dmax>leftDensity).*(leftDensity>inLink1.dc))+...
        0.*(leftDensity>=inLink1.dmax)+0.*(leftDensity<=0));
% bounding by ratio of flow sending by link 1 (13o)
q13ol = q13oLaneRatio1 * s1;
% bounding by ratio of flow sending by link 1 (13s)
q13sl = splitRatio * q13sLaneRatio1 * s1;
% bounding by ratio of flow sending by link 1 (14s)
q14sl = (1-splitRatio) * q13sLaneRatio1 * s1;
% bounding by ratio of flow sending by link 1 (14o)
q14ol = q14oLaneRatio1 * s1;

%% receiving of link 3
% r3 = receiving(rightDensity1,outLink1.vmax,...
%     outLink1.dmax,...
%     outLink1.dc);
r3 = (rightDensity1 >= outLink1.dc) .* ( outLink1.vmax*rightDensity1.*((0<rightDensity1).*(rightDensity1<=outLink1.dc))+...
        (outLink1.dc*outLink1.vmax)*(outLink1.dmax-rightDensity1)./(outLink1.dmax-outLink1.dc).*((outLink1.dmax>rightDensity1).*(rightDensity1>outLink1.dc))+...
        0.*(rightDensity1>=outLink1.dmax)+0.*(rightDensity1<=0)) + (rightDensity1 < outLink1.dc).*(outLink1.vmax*outLink1.dc);
% bounding by receiving of link 3 (13o)
q13or= q13oLaneRatio2 * r3;
% bounding by receiving of link 3 (13s)
q13sr = q13sLaneRatio2 * r3;

%% receiving of link 4
% r4 = receiving(rightDensity2,outLink2.vmax,...
%     outLink2.dmax,...
%     outLink2.dc);
r4 = (rightDensity2 >= outLink2.dc) .* ( outLink2.vmax*rightDensity2.*((0<rightDensity2).*(rightDensity2<=outLink2.dc))+...
        (outLink2.dc*outLink2.vmax)*(outLink2.dmax-rightDensity2)./(outLink2.dmax-outLink2.dc).*((outLink2.dmax>rightDensity2).*(rightDensity2>outLink2.dc))+...
        0.*(rightDensity2>=outLink2.dmax)+0.*(rightDensity2<=0)) + (rightDensity2 < outLink2.dc).*(outLink2.vmax*outLink2.dc);
% bounding by receiving of link 4 (14s)
q14sr = q14sLaneRatio2 * r4;
% bounding by receiving of link 4 (14o)
q14or = q14oLaneRatio2 * r4;


%% get the min(sending, receiving)
A = [q13ol q13or];
B = [q13sl q13sr]; 
C = [q14ol q14or];
D = [q14sl q14sr]; 
q13o = min(A);
q13s = min(B);
q14o = min(C);
q14s = min(D);

q1 = q13o + q13s + q14o + q14s;
q13 = q13o + q13s ;
q14 = q14o + q14s;

result=[q1 q13 q14];