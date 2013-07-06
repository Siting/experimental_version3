function[ACCEPTED_POP] = trimExessiveSamples(ACCEPTED_POP,populationSize)

% linkIDs = ACCEPTED_POP.keys;

for i = 1 : length(ACCEPTED_POP)
    samplesInfo = ACCEPTED_POP(i);
    samplesInfo.samples = samplesInfo.samples(:,1 : populationSize);
    ACCEPTED_POP(i) = samplesInfo;
end