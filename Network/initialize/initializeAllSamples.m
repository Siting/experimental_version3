function[ALL_SAMPLES] = initializeAllSamples(linkMap)

% struct: linkID, samples

% ALL_SAMPLES = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');

linkIDs = linkMap.keys;

samples = [];

for i = 1 : length(linkIDs)
    all_Samples = struct('linkID',linkIDs{i}, 'samples', samples);
    ALL_SAMPLES(i) = all_Samples;
end