function[JUNCTION] = loadNodeRatio(configID,JUNCTION,junctionSolverType,LINK)

% junctionIds = JUNCTION.keys;

% open file
fileName = (['.\Configurations\node_ratio\NODE_RATIO_CONFIG-' num2str(configID) '.csv']);
fid=fopen(fileName);
% disp(['opening file: ' fileName]);
nodeRatioData=textscan(fid,'%d %f','delimiter',',','headerlines',1);
fclose(fid);

% node ratio is the concept for one lane
nodeRatio=nodeRatioData{2};

% check if all junction has been assigned value


for i = 1 : length(JUNCTION)
    junction = JUNCTION(i);
    junction.ratio = nodeRatio(i);
    % laneRatio is the concept for whole junction
    % diverge junction
    if junction.numIncomingLinks == 1 && ...
            junction.numOutgoingLinks == 2
        if strcmp(junctionSolverType,'multi-lane model')
            junction.splitLaneRatio = (junction.num_JunctionA + junction.ratio)/...
                (junction.num_JunctionA + junction.num_JunctionB + ...
                junction.num_JunctionC);
        elseif strcmp(junctionSolverType,'single lane model')
            junction.splitLaneRatio = junction.ratio;
        end
        % merge junctions
    elseif junction.numIncomingLinks == 2 &&...
            junction.numOutgoingLinks == 1
        if strcmp(junctionSolverType,'multi-lane model')
            if strcmp(junction.junctionType,'merge more')
                junction.mergeLaneRatio = (junction.num_JunctionA+junction.ratio)/(junction.num_JunctionA+...
                    junction.num_JunctionB + junction.num_JunctionC);
            elseif strcmp(junction.junctionType,'merge equal')
                junction.mergeLaneRatio = LINK(junction.incomingLink_1_ID).numLanes/...
                    LINK(junction.outgoingLink_1_ID).numLanes;
            end
        elseif strcmp(junctionSolverType,'single lane model')
            junction.mergeLaneRatio = junction.ratio;
        end
    end
    JUNCTION(i) = junction;
end

