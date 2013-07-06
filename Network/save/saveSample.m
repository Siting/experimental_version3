function[REJECTED_POP] = saveSample(REJECTED_POP, sample, ALL_SAMPLES)

% linkIDs = ALL_SAMPLES.keys;

for i = 1 : length(ALL_SAMPLES)
    sampleOfLink = ALL_SAMPLES(i).samples(:,sample);
    linkSamples = REJECTED_POP(i);
    linkSamples.samples = [linkSamples.samples sampleOfLink];
    REJECTED_POP(i) = linkSamples;
end