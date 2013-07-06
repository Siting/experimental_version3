%% Discretization
function[LINK, numCellsInNetwork] = discretizeLinks(LINK,deltaT)


% linkIds = LINK.keys;

% First: pick the maximum speed
% Second: set minimum deltaX
vmaxCFL = -1;
 
 for i = 1 : length(LINK)
     link = LINK(i);
     vmaxCFL = max(link.vmax,vmaxCFL);
 end
 minDeltaX = vmaxCFL * deltaT;

% First: compute number of cells on each link
% Second: set cell index
 index = 1;
 for i = 1 : length(LINK)
     link = LINK(i);
     
     link.numCells = floor(link.length/minDeltaX);
     link.cellIndex = [index:1:(index+link.numCells-1)];
     link.deltaX = link.length/link.numCells;
     index = index + link.numCells;
     LINK(i) = link;
 end
 numCellsInNetwork = index - 1;