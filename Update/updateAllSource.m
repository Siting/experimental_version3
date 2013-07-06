function[sourceFeed] = updateAllSource(SOURCE_LINK,page,nT)

% linkIds = SOURCE_LINK.keys;

for i = 1 : length(SOURCE_LINK)
    link = SOURCE_LINK(i);
    outgoingLinkID = link.outgoingLinkID;
    sourceFeed(outgoingLinkID) = link.densityResult(ceil((page-1)/nT));
end