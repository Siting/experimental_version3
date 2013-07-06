function[LINK, JUNCTION, SOURCE_LINK, SINK_LINK] = preloadAndCompute(linkMap, nodeMap, T)

[LINK] = preLoadLinks(linkMap);

[JUNCTION] = preloadJunctions(nodeMap, LINK);

% [RATIO] = precomputeLaneRatioForJunctions(JUNCTION);

[SOURCE_LINK, SINK_LINK] = preloadSourceSink(nodeMap, T);
