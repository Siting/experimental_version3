function[thresholdVector, criteria] = pickThresholdValue(stage, configID)

global expectAR
% load errorCollection matrix from the previous stage
load(['.\Result\evolutionData\config-' num2str(configID) '\-errorCollection-stage-' num2str(stage-1) '.mat']);

% sort array in ascending order
errorArray = sort(errorCollectionForStage, 'ascend');

% take the average of +/-3 numbers around the expectAR value
% floor: make sure index is an integer
index = floor(size(errorArray,2) * expectAR);
criteria = mean(errorArray(index-3:index+3));

% assign to thresholdVector
thresholdVector(stage,:) = [criteria criteria];

