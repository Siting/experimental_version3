function[SOURCE_LINK, SINK_LINK] = setFundamentalParameters_network(SOURCE_LINK, SINK_LINK, FUNDAMENTAL, linkMap, LINK)

global funsOption

% linkIDs = SOURCE_LINK.keys;
for i = 1 : length(SOURCE_LINK)
    link = SOURCE_LINK(i);
    
    if funsOption == 1
        link.vmax = FUNDAMENTAL.vmax;
        link.dc = linkMap(link.outgoingLinkID).numberOfLanes * FUNDAMENTAL.dc;
        link.dmax = linkMap(link.outgoingLinkID).numberOfLanes * FUNDAMENTAL.dmax;
    elseif funsOption == 2
        outgoingLink = LINK(link.outgoingLinkID);
        link.vmax = outgoingLink.vmax;
        link.dmax = outgoingLink.dmax;
        link.dc =  outgoingLink.dc;
    end
    
    SOURCE_LINK(i) = link;
end

% linkIDs = SINK_LINK.keys;
for i = 1 : length(SINK_LINK)
    link = SINK_LINK(i);
    if funsOption == 1
        link.vmax = FUNDAMENTAL.vmax;
        link.dc = linkMap(link.incomingLinkID).numberOfLanes * FUNDAMENTAL.dc;
        link.dmax = linkMap(link.incomingLinkID).numberOfLanes * FUNDAMENTAL.dmax;
    elseif funsOption == 2
        incomingLink = LINK(link.incomingLinkID);
        link.vmax = incomingLink.vmax;
        link.dmax = incomingLink.dmax;
        link.dc =  incomingLink.dc;
    end
    SINK_LINK(i) = link;
end