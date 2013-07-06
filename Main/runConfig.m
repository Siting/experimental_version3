function[]=runConfig(configID)

% tasks=======================================================
% load configuration info. 
% load configuration parameters
% check running mode. measurement generation? Or estimation?
% end=========================================================


%% load configuration settings
load(['.\Configurations\configs\CONFIG-' num2str(configID)]);
parameterID = CONFIG.parameterID;
load(['.\Configurations\parameters\PARAMETER-' num2str(parameterID)]);

%% run configuration
if strcmp(CONFIG.measurement_generation_mode,'on')
    measurement_generation(CONFIG,PARAMETER,configID);
end

if strcmp(CONFIG.estimation_mode,'on')
    estimation(CONFIG,PARAMETER,configID);
end

if strcmp(CONFIG.particle,'on')
    particleEstimation(CONFIG,PARAMETER,configID);
end

if (strcmp(CONFIG.ABC, 'on') && strcmp(CONFIG.ABCrejection, 'on'))
    parameterCalibrationABC(CONFIG,PARAMETER,configID);
end

if (strcmp(CONFIG.ABC, 'on') && strcmp(CONFIG.ABCSMC, 'on'))
    parameterCalibrationABCSMC(CONFIG,PARAMETER,configID);
end


