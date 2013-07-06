function[LINK] = runForwardSimulation(LINK,SOURCE_LINK,SINK_LINK,JUNCTION,...
deltaT,numEns,numTimeSteps,nT,junctionSolverType)


% start from ensemble 1 to the numEns
% 1st: extract the right ensemble
% 2nd: feed in the forwardSim function
% page will be the one get updated
% the first page is the initial state

for timeStep = 1 : numTimeSteps
    
    page = timeStep+1;
    
    for ensemble = 1 : numEns
        [LINK] = forwardSim(LINK, SOURCE_LINK, SINK_LINK, JUNCTION, page, deltaT, ensemble, nT, junctionSolverType);
    end
        
end