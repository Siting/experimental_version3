function[]=measurement_generation(CONFIG,PARAMETER,configID)

%% Get network, parameters, initial state, boundary condition details========================================
[deltaTinSecond, deltaT, nT, numIntervals, numEns,...
    startString, endString, startTime, unixTimeStep, FUNDAMENTAL, trueNodeRatio,...
    vmaxVar, dmaxVar, dcVar, trueNodeRatioVar, modelFirst, modelLast, populationSize,...
    samplingSize, criteria, stateNoiseGamma, measNoiseGamma, etaW, junctionSolverType,...
    numTimeSteps, samplingInterval, trueStateErrorMean, trueStateErrorVar,...
    measConfigID, measNetworkID, caliNetworkID, testingDataFolder, evolutionDataFolder, sensorDataFolder, configID, T] = getConfigAndPara(CONFIG,PARAMETER);

load([measNetworkID, '-graph.mat']);
disp([measNetworkID, '-graph loaded']);

% end=========================================================================================================

%% Load Links (main links, source links, sink links)
% denote links as LINK(i)
% length: mile
% vmax: miles/hour
% dmax: vehs/mile
% dc: vehs/mile
[LINK] = loadLinks(linkMap,FUNDAMENTAL, configID);
% disp('links loaded');

%% Load Souces and Sinks
[SOURCE_LINK, SINK_LINK] = loadSourceSinkLinks(nodeMap,FUNDAMENTAL, LINK);
% disp('souces and sinks loaded'); 

%% Load Junctions
% denote junctions as JUNCTION(i)
% num_JunctionA denotes number of lanes of upper section which only goes to one downstream (downstream)
% num_JunctionB denotes number of lanes of middle section which goes to both downstreams
% num_JunctionC denotes number of lanes of lower section which only goes to one downstream (connector)
% Link number set as counterclockwise from left upper
[JUNCTION] = loadJunctions(nodeMap,LINK);
% disp('junctions loaded');

%% Set junction ratio
[JUNCTION] = loadNodeRatio(configID,JUNCTION,junctionSolverType,LINK);
% disp('junction ratio set');
% pause(1);

%% Initial Links
% First step: discretization
  % deltaX: mile
  % deltaT: hour
  % struct DELTA
% Sencond step: initialize density of each link
  % struct INITIAL_VALUE
  % set the initial value as LINK(i).densityResult(:,:,1)
% Density is a three-dimensional matrix: 1st is cell index, 2nd is 
% ensemble index, 3rd is the time index
[LINK,numCellsNet] = initializeAllLinks(LINK,deltaT,numEns,CONFIG);
% disp('initializtion completed');

%% Feed in boundary condition
[SOURCE_LINK, SINK_LINK] = loadBoundaryCondtion(SOURCE_LINK,SINK_LINK,numIntervals,CONFIG);
% disp('boundary condition loaded');
% pause(1);

%% Generate "true" state 
% will have page = numTimeSteps + 1
disp('start forward simulation');

[LINK] = runForwardSimulation(LINK,SOURCE_LINK,SINK_LINK,JUNCTION,...
    deltaT,numEns,numTimeSteps,nT,junctionSolverType);
disp('measurements generated');

%% save density result for all timesteps as .mat file
[SENSOR_DATA_MATRIX SENSOR_CELL_INDEX LINK_WITH_SENSOR] = createTxtFileMatrix(LINK,sensorMetaDataMap,numEns,numTimeSteps,samplingInterval,...
    startTime,unixTimeStep,trueStateErrorMean,trueStateErrorVar);
% disp('sensor data matrix generated');

%% write text file
% writeTxtFile(SENSOR_DATA_MATRIX, testingDataFolder, trueStateErrorVar);
% disp('txt file generated');

%% save results
% SENSOR_CELL_INDEX is a container. struct('sensorID',[],'cellIndexNet',[],'cellIndexLink',[])
save([evolutionDataFolder '\SENSOR_CELL_INDEX-CONFIG-' num2str(configID)],'SENSOR_CELL_INDEX');
% measurements=SENSOR_DATA_MATRIX(sensorID).matrix(:,5)
save([evolutionDataFolder '\measurements-CONFIG-' num2str(configID)],'SENSOR_DATA_MATRIX');
% all links density results
save([evolutionDataFolder '\LINK-CONFIG-' num2str(configID)],'LINK');
% LINK_WITH_SENSOR is a container. struct('linkID',[],'sensorID',[])
save([evolutionDataFolder '\LINK_WITH_SENSOR-CONFIG-' num2str(configID)],'LINK_WITH_SENSOR');

% %% save density evolution result of sensor and adjacent cell
% if configID == 1 || configID == 3
%     saveTestingCells(LINK,SENSOR_CELL_INDEX, PARAMETER, configID);
% elseif configID == 11
%     saveTestingCells_diverge(LINK,SENSOR_CELL_INDEX,PARAMETER);
% end

% save sensor data
saveSensorData2Mat(SENSOR_DATA_MATRIX, CONFIG, PARAMETER);


disp('configuration results saved');

disp('measurements generation completed');


