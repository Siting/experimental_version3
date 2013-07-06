function[PARAMETER]=setParameter32(PARAMETER)

% This file contains parameter settings for ABC algorithm

PARAMETER.parameterID=32;
PARAMETER.T=0.1;                         % time intervals (mins)
PARAMETER.deltaTinSencond=6;           % each time step is 6s long
PARAMETER.deltaT=secondsToHour(6);     % unit: hour
PARAMETER.nT=ceil(minutesToHour(PARAMETER.T)/PARAMETER.deltaT);   % # time steps in one interval
PARAMETER.samplingInterval = 1;          % sample density every # time steps

PARAMETER.startString='2011-10-22 00:00:00.000';
PARAMETER.endString='2011-10-22 00:06:00.000';
PARAMETER.startTime=datenum(PARAMETER.startString);
PARAMETER.unixTimeStep=PARAMETER.deltaTinSencond*1/24/3600;

% compute number of intervals
endTime=datenum(PARAMETER.endString);
unixTimeInterval=PARAMETER.T/(24*60);
PARAMETER.numIntervals=round((endTime-PARAMETER.startTime)/unixTimeInterval);        

% fundamental diagram parameters
PARAMETER.vmax = 65;
PARAMETER.dmax = 150;
PARAMETER.dc = 30;
PARAMETER.FUNDAMENTAL=struct('vmax',PARAMETER.vmax,'dmax',PARAMETER.dmax,'dc',PARAMETER.dc);

% split ratio
PARAMETER.trueNodeRatio=0.5;

PARAMETER.numEns=1;
PARAMETER.etaW=0;
PARAMETER.trueStateErrorMean=0;
PARAMETER.trueStateErrorVar=0;
PARAMETER.stateNoiseGamma=0;
PARAMETER.measNoiseGamma=0;

%% New add-ons for Approximate Bayesian Computation 
PARAMETER.vmaxVar = 0;
PARAMETER.dmaxVar = 0;
PARAMETER.dcVar = 0;
PARAMETER.trueNodeRatioVar = 0;
PARAMETER.modelFirst = 1;    % for model selection function
PARAMETER.modelLast = 1;     % for model selection function
PARAMETER.populationSize = 1;
PARAMETER.samplingSize = 1;
PARAMETER.criteria = [];