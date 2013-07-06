function[node] = setIncomingLinksID(node,NTnode)

% handle up to 2 incoming links

% one incoming link?
if length(NTnode.incomingLinks) == 1
    % source?
     if NTnode.incomingLinks(1) == -1
         node.incomingLink_1_ID = NTnode.sources.sourceIds;
    % sink
     else
         node.incomingLink_1_ID = NTnode.incomingLinks;
     end
% two incoming links?
elseif length(NTnode.incomingLinks) == 2
    node.incomingLink_1_ID = NTnode.incomingLinks(1);
    node.incomingLink_2_ID = NTnode.incomingLinks(2);
    
% more than 2 incoming links
else 
    disp('Number of incoming links is larger than 2.');
end
    