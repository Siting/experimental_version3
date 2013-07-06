function[node] = setOutgoingLinksID(node,NTnode)

% handle up to 2 outgoing links

% one outgoing link?
if length(NTnode.outgoingLinks) == 1
    % sink?
    if NTnode.outgoingLinks(1) == -1
        node.outgoingLink_1_ID = NTnode.sinks.sinkIds;
    % source
    else 
        node.outgoingLink_1_ID = NTnode.outgoingLinks;
    end
% two outgoing links?
elseif length(NTnode.outgoingLinks) == 2
    node.outgoingLink_1_ID = NTnode.outgoingLinks(1);
    node.outgoingLink_2_ID = NTnode.outgoingLinks(2);
    
% more than 2 outgoing links
else 
    disp('Number of outgoing links is more than 2.');
end