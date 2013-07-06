function[sourceFeed sinkFeed]=updateSouceSink(SOURCE_LINK,SINK_LINK,timeStep)

sourceFeed=updateAllSource(SOURCE_LINK,timeStep);
sinkFeed=updateAllSink(SINK_LINK,timeStep);