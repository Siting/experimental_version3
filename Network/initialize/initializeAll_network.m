function[LINK, SOURCE_LINK, SINK_LINK, JUNCTION, numCellsNet, ALL_SAMPLES, numLanes] = initializeAll_network(FUNDAMENTAL, linkMap, JUNCTION, deltaT,...
    numEns, CONFIG, ALL_SAMPLES, SOURCE_LINK, SINK_LINK, junctionSolverType, LINK)

% Load Links (main links, source links, sink links)
% denote links as LINK(i)
% length: mile
% vmax: miles/hour
% dmax: vehs/mile
% dc: vehs/mile
[LINK] = loadLinksNew(linkMap, FUNDAMENTAL,CONFIG.configID, LINK);
ALL_SAMPLES = saveSamplesForLinks(LINK, ALL_SAMPLES);
numLanes = LINK(1).numLanes;

% Load Junctions
% denote junctions as JUNCTION(i)
% num_JunctionA denotes number of lanes of upper section which only goes to one downstream (downstream)
% num_JunctionB denotes number of lanes of middle section which goes to both downstreams
% num_JunctionC denotes number of lanes of lower section which only goes to one downstream (connector)
% Link number set as counterclockwise from left upper
% [JUNCTION] = loadJunctions(nodeMap, LINK);

% Set junction ratio
[JUNCTION] = loadNodeRatio(CONFIG.configID,JUNCTION,junctionSolverType,LINK);

% Initialize Links
% First step: discretization
% deltaX: mile
% deltaT: hour
% struct DELTA
% Sencond step: initialize density of each link
% struct INITIAL_VALUE
% set the initial value as LINK(i).densityResult(:,1)
[LINK,numCellsNet] = initializeAllLinks(LINK, deltaT, numEns, CONFIG);

% Set up FUNDAMENTAL parameters for SOURCE_LINK, SINK_LINK
[SOURCE_LINK, SINK_LINK] = setFundamentalParameters_network(SOURCE_LINK, SINK_LINK, FUNDAMENTAL, linkMap, LINK);

