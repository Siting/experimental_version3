function[ACCEPTED_POP] = saveSample(ACCEPTED_POP, sample, ALL_SAMPLES)

% linkIDs = ALL_SAMPLES.keys;

for i = 1 : length(ALL_SAMPLES)
    sampleOfLink = ALL_SAMPLES(i).samples(:,sample);
    linkSamples = ACCEPTED_POP(i);
    linkSamples.samples = [linkSamples.samples sampleOfLink];
    ACCEPTED_POP(i) = linkSamples;
end