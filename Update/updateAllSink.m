function[sinkFeed] = updateAllSink(SINK_LINK,page,nT)

% linkIds = SINK_LINK.keys;

for i = 1 : length(SINK_LINK)
    link = SINK_LINK(i);
    incomingLinkID = link.incomingLinkID;

    sinkFeed(incomingLinkID) = link.densityResult(ceil((page-1)/nT));
end