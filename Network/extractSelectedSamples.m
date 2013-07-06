function[POST_ACCEPTED_POP] = extractSelectedSamples(indexCollection, ACCEPTED_POP)

% linkIDs = ACCEPTED_POP.keys;

for i = 1 : length(ACCEPTED_POP)
    sampleInfo = ACCEPTED_POP(i);
    sampleInfo.samples = sampleInfo.samples(:,indexCollection);
    POST_ACCEPTED_POP(i) = struct('linkID',i, 'samples', []);
    POST_ACCEPTED_POP(i).samples = sampleInfo.samples;
end
