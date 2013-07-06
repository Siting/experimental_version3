function[LINK] = preLoadLinks(linkMap)

% did not set fundamental diagram for any link in this file

% LINK = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');
% 
linkIds = linkMap.keys;

for i = length(linkIds) : -1 : 1
    NTlink = linkMap(linkIds{i});
    LINK(i) = struct('linkId',NTlink.linkId,'incomingNode',NTlink.incomingNode,...
        'outgoingNode',NTlink.outgoingNode,'numLanes',NTlink.numberOfLanes,...
        'length',NTlink.lengthInMiles,'startLatLon',NTlink.startLatLon,...
        'endLatLon',NTlink.endLatLon,'vmax',[],'dmax',[],'dc',[],...
        'numCells',[],'leftFlux',[],'rightFlux',[],'deltaX',[],'densityResult',[],...
        'cellIndex',[],'offsetFromGraph',[],'sensors',NTlink.sensors);

%     LINK(linkIds{i}) = link;
end