function[ACCEPTED_POP, REJECTED_POP] = initializeAcceptedRejected(linkMap)

% struct: linkID, samples(accepted)
% struct: linkID, samples(rejected)

% ACCEPTED_POP = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');
% 
% REJECTED_POP = containers.Map( ...
%     'KeyType', 'int64', 'ValueType', 'any');

linkIDs = linkMap.keys;

samples = [];

for i = 1 : length(linkIDs)
    all_Samples = struct('linkID',linkIDs{i}, 'samples', samples);
    ACCEPTED_POP(i) = all_Samples;
    REJECTED_POP(i) = all_Samples;
end