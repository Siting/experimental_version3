function[] = configuration_setting(configID)

%% This file retrieves all the configuration info and save them as .mat to designated folders

%% load configuration info.
% configID is the ID of those configuration set(s) which will be saved 
for i = 1 : length(configID)
    CONFIG = struct('caliConfigID', [], 'measConfigID', [], 'measNetworkID', [], 'caliNetworkID', [], 'parameterID', [], 'initialStateID', [],...
        'boundaryConditionID', [], 'junctionSolverType', [], 'measurement_generation_mode', [], 'estimation', [],...
        'particle', [], 'ABC', [], 'ABCrejection', [], 'ABCSMC', [], 'testingDataFolder', [], 'evolutionDataFolder', [],...
        'sensorDataFolder', []);
    CONFIG = loadConfigFiles(CONFIG, configID(i));
    save(['.\Configurations\configs\CONFIG-' num2str(configID(i))],'CONFIG');
end

%% load parameter info.
parameterID = configID;
for i = 1:length(parameterID)
    PARAMETER = struct('parameterID',[],'T',[],'deltaTinSecond',[],'deltaT',[],'nT',[],'numIntervals',[],'numTimeSteps',[],...
        'samplingInterval',[],'numEns',[],'startString',[],'endString',[],'startTimeDate',[],'unixTimeStep',[],'FUNDAMENTAL',[],...
        'trueNodeRatio',[],'trueStateErrorMean',[],'trueStateErrorVar',[],'stateNoiseGamma',[],'measNoiseGamma',[],'vmax',[],...
        'dmax',[],'dc',[],'vmaxVar',[],'dmaxVar',[],'dcVar',[],'trueNodeRatioVar',[],'modelFirst',[],'modelLast',[],...
        'populationSize',[],'samplingSize',[],'criteria',[], 'startTime', [], 'endTime', [], 'thresholdVector', []);
    PARAMETER = loadParameterFiles(PARAMETER,parameterID(i));
    save(['.\Configurations\parameters\PARAMETER-' num2str(parameterID(i))],'PARAMETER');
end

disp('configuration setting finished');