function[LINK] = updateAllJunctions(sourceFeed, sinkFeed, JUNCTION,LINK,page,ensemble,...
    SOURCE_LINK,SINK_LINK, junctionSolverType)

% nodeIds = JUNCTION.keys;

for i = 1:length(JUNCTION)

    node = JUNCTION(i);       
    
    if strfind(node.junctionType, 'merge')
        [LINK] = merge(node, LINK,page,ensemble,junctionSolverType);
    elseif isempty(strfind(node.junctionType, 'diverge'))
        [LINK] = oneToOne(sourceFeed,sinkFeed,node, LINK,page,ensemble,SOURCE_LINK,SINK_LINK);
    else
        [LINK] = diverge(node, LINK,page,ensemble,junctionSolverType);
    end

%     function2call = ([node.solverName 'New']);
%     cf = str2func(function2call);
%     LINK = cf(sourceFeed,sinkFeed, node, LINK,page,ensemble,junctionSolverType, SOURCE_LINK,SINK_LINK);
    
end 

                                                                                                                                                                                                                                                                                                                                                                    