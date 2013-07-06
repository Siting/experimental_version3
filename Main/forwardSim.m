function[LINK] = forwardSim(LINK,SOURCE_LINK,SINK_LINK,JUNCTION,page,...
    deltaT,ensemble,nT,junctionSolverType)

[sourceFeed, sinkFeed] = updateFeedInData(SOURCE_LINK,SINK_LINK,page,nT);

[LINK] = updateAllJunctions(sourceFeed, sinkFeed, JUNCTION,LINK,page,ensemble,SOURCE_LINK,SINK_LINK, junctionSolverType);

[LINK] = updateAllLinks(LINK,deltaT,page,ensemble);