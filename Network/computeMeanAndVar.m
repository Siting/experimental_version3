function[meanForLinks, varForLinks] = computeMeanAndVar(ACCEPTED_POP)

% linkIDs = ACCEPTED_POP.keys;

meanForLinks = [];
varForLinks = [];

for i = 1 : length(ACCEPTED_POP)
    sampleInfo = ACCEPTED_POP(i);
    matrix = sampleInfo.samples;
    meanLink = mean(matrix,2);
    varVmax = var(matrix(1,:));
    varDmax = var(matrix(2,:));
    varDc = var(matrix(3,:));
    varLink = [varVmax; varDmax; varDc];
    meanForLinks = [meanForLinks meanLink];
    varForLinks = [varForLinks varLink];
end