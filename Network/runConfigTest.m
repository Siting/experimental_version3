function[]=runConfigTest(configID, i)

global ABC_selection_type
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
% 
% if strcmp(CONFIG.estimation_mode,'on')
%     estimation(CONFIG,PARAMETER,configID);
% end
% 
% if strcmp(CONFIG.particle,'on')
%     particleEstimation(CONFIG,PARAMETER,configID);
% end
% 
% if (strcmp(CONFIG.ABC, 'on') && strcmp(CONFIG.ABCrejection, 'on'))
% %     PARAMETER.criteria = criteriaVector(i);
%     parameterCalibrationABCRS_network2(CONFIG,PARAMETER,configID);
% end
% 
% if (strcmp(CONFIG.ABC, 'on') && strcmp(CONFIG.ABCSMC, 'on') && ABC_selection_type == 1)
%     parameterCalibrationABCSMCTest1(CONFIG,PARAMETER,configID);
% end

if (strcmp(CONFIG.ABC, 'on') && strcmp(CONFIG.ABCSMC, 'on') && ABC_selection_type == 2)
    parameterCalibrationABCSMC_network(CONFIG,PARAMETER,configID);
end

if strcmp(CONFIG.measurement_generation_mode,'on')
    measurement_generation(CONFIG,PARAMETER,configID);
end


