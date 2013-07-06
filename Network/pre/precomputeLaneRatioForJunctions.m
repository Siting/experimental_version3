function[JUNCTION] = precomputeLaneRatioForJunctions(JUNCTION)

nodeIDs = JUNCTION.keys;

for i = 1 : length(nodeIDs)
    
    nodeID = nodeIDs{i};
    
    % not a sink or source
    if min(JUNCTION(nodeIDs{i}).incomingLinks ~= -1) && min(JUNCTION(nodeIDs{i}).outgoingLinks ~= -1)
        
        ratio = struct('q13oLaneRatio1',[],'q13sLaneRatio1',[],'q23sLaneRatio1',[],...
        'q23oLaneRatio1',[],'q13oLaneRatio2',[],'q13sLaneRatio2',[],'q23sLaneRatio2',[],'q23oLaneRatio2',[],...
        'q14sLaneRatio1',[],'q14oLaneRatio1',[],'q14sLaneRatio2',[], 'q14oLaneRatio2', []);

        if strcmp(JUNCTION(nodeID).junctionType,'merge more')
            [ratio.q13oLaneRatio1, ratio.q13sLaneRatio1, ratio.q23sLaneRatio1, ratio.q23oLaneRatio1...
                ratio.q13oLaneRatio2, ratio.q13sLaneRatio2, ratio.q23sLaneRatio2, ratio.q23oLaneRatio2] = ...
                computeLaneRatioForMergeMore(JUNCTION, nodeID);
%             save(['node-' num2str(nodeID) '-junctionLaneRatio'],'q13oLaneRatio1', 'q13sLaneRatio1', 'q23sLaneRatio1', 'q23oLaneRatio1',...
%                 'q13oLaneRatio2', 'q13sLaneRatio2', 'q23sLaneRatio2', 'q23oLaneRatio2');
        elseif strcmp(JUNCTION(nodeID).junctionType,'diverge less')
            [ratio.q13oLaneRatio1, ratio.q13sLaneRatio1, ratio.q14sLaneRatio1, ratio.q14oLaneRatio1,...
                ratio.q13oLaneRatio2, ratio.q13sLaneRatio2, ratio.q14sLaneRatio2, ratio.q14oLaneRatio2]...
                = computeLaneRatioForDivergeLess(JUNCTION,nodeID);
%             save(['node-' num2str(nodeID) '-junctionLaneRatio'],'q13oLaneRatio1', 'q13sLaneRatio1', 'q14sLaneRatio1', 'q14oLaneRatio1',...
%                 'q13oLaneRatio2', 'q13sLaneRatio2', 'q14sLaneRatio2', 'q14oLaneRatio2');
        end
        
        RATIO(nodeIDs{i}) = ratio;
    end
end
% keyboard