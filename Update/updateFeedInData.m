function[sourceFeed, sinkFeed] = updateFeedInData(SOURCE_LINK,SINK_LINK,page,nT)

sourceFeed = updateAllSource(SOURCE_LINK,page,nT);
sinkFeed = updateAllSink(SINK_LINK,page,nT);