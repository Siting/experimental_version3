function[SOURCE_LINK, SINK_LINK] = setSourceSinkSample(SOURCE_LINK, SINK_LINK, LINK)

% linkIDs = SOURCE_LINK.keys;
for i = 1 : length(SOURCE_LINK)
    link = SOURCE_LINK(i);    
    
    outgoingLink = LINK(link.outgoingLinkID);
    link.vmax = outgoingLink.vmax;
    link.dmax = outgoingLink.dmax;
    link.dc =  outgoingLink.dc;
       
    SOURCE_LINK(i) = link;
end

% linkIDs = SINK_LINK.keys;
for i = 1 : length(SINK_LINK)
    link = SINK_LINK(i);
    
    incomingLink = LINK(link.incomingLinkID);
    link.vmax = incomingLink.vmax;
    link.dmax = incomingLink.dmax;
    link.dc =  incomingLink.dc;
    
    SINK_LINK(i) = link;
end