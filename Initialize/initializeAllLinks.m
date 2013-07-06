%% Initialize Links
function[LINK, numCellsNet] = initializeAllLinks(LINK,deltaT,numEns,CONFIG)

[LINK,numCellsNet] = discretizeLinks(LINK,deltaT);

[LINK] = initializeDensity(LINK,numEns,CONFIG);