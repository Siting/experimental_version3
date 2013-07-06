function[PARAMETER]=loadParameterFiles(PARAMETER,parameterID)

function2call=(['setParameter' num2str(parameterID)]);
pf=str2func(function2call);
PARAMETER=pf(PARAMETER);