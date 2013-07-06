function[CONFIG] = loadConfigFiles(CONFIG,configID)

function2call = (['setConfig' num2str(configID)]);
cf = str2func(function2call);
CONFIG = cf(CONFIG);
