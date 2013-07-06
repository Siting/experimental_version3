function[NEW_ACCEPTED_POP] = saveNewSamples(NEW_ACCEPTED_POP, POPULATION_3)

% linkIDs = POPULATION_3.keys;

for i = 1 : length(POPULATION_3)
    newSampleInfo = NEW_ACCEPTED_POP(i);
    sampleInfo = POPULATION_3(i);
    newSampleInfo.samples = [newSampleInfo.samples sampleInfo.samples];
    NEW_ACCEPTED_POP(i) = newSampleInfo;
end