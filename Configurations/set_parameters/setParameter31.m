function[PARAMETER]=setParameter31(PARAMETER)

PARAMETER.parameterID=31;
PARAMETER.T=0.1;                         % time intervals (mins)
PARAMETER.deltaTinSencond=6;           % each time step is 6s long
PARAMETER.deltaT=secondsToHour(6);     % unit: hour
PARAMETER.nT=ceil(minutesToHour(PARAMETER.T)/PARAMETER.deltaT);   % # time steps in one interval
PARAMETER.samplingInterval = 1;          % sample density every # time steps

PARAMETER.startString='2011-10-22 00:00:00.000';
PARAMETER.endString='2011-10-22 00:25:00.000';
PARAMETER.startTime=datenum(PARAMETER.startString);
PARAMETER.unixTimeStep=PARAMETER.deltaTinSencond*1/24/3600;

% compute number of intervals
endTime=datenum(PARAMETER.endString);
unixTimeInterval=PARAMETER.T/(24*60);
PARAMETER.numIntervals=round((endTime-PARAMETER.startTime)/unixTimeInterval);        

% fundamental diagram parameters
PARAMETER.vmax=65;
PARAMETER.dmax=150;
PARAMETER.dc=30;
PARAMETER.FUNDAMENTAL=struct('vmax',PARAMETER.vmax,'dmax',PARAMETER.dmax,'dc',PARAMETER.dc);

% split ratio
PARAMETER.trueNodeRatio=0.5;

PARAMETER.numEns=1;
PARAMETER.etaW=0;
PARAMETER.trueStateErrorMean=0;
PARAMETER.trueStateErrorVar = 4;