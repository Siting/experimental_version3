%% Compute Lane Ratio
function[q13oLaneRatio1 q13sLaneRatio1 q14sLaneRatio1 ...
    q14oLaneRatio1 q13oLaneRatio2 q13sLaneRatio2 q14sLaneRatio2 q14oLaneRatio2]=computeLaneRatioForDivergeLess(node)


leftNumLanes=node.num_JunctionA+node.num_JunctionB+node.num_JunctionC;
% LHS
q13oLaneRatio1=node.num_JunctionA/leftNumLanes;
q13sLaneRatio1=node.num_JunctionB/leftNumLanes;
q14sLaneRatio1=node.num_JunctionB/leftNumLanes;
q14oLaneRatio1=node.num_JunctionC/leftNumLanes;
% RHS
q13oLaneRatio2=node.num_JunctionA/(node.num_JunctionA+node.num_JunctionB);
q13sLaneRatio2=node.num_JunctionB/(node.num_JunctionA+node.num_JunctionB);
q14sLaneRatio2=node.num_JunctionB/(node.num_JunctionB+node.num_JunctionC);
q14oLaneRatio2=node.num_JunctionC/(node.num_JunctionB+node.num_JunctionC);