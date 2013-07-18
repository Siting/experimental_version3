% study rejected samples by stages
clear all
clc

series = 15;
studyStages = [1;2;3;4;5; 6; 7];
numSamplesStudied = 100;
cali_configID = 41;
cali_paraID = 41;
simu_configID = 115;
testingSensorIDs = [400739; 400363];

load(['.\Configurations\parameters\PARAMETER-' num2str(cali_paraID) '.mat']);

% noisy sensor data
[sensorDataMatrix] = getNoisySensorData_network(testingSensorIDs, PARAMETER.T,...
    PARAMETER.startTime, PARAMETER.endTime);

% load errorCollection matrix
errorCollectionStages = [];
for i = 1 : length(studyStages)
    load(['.\ResultCollection\series' num2str(series) '\-errorCollection-stage-' num2str(studyStages(i)) '.mat']);
    errorCollectionForStage = errorCollectionForStage(1:numSamplesStudied)';   % an array of errors for each sample
    errorCollectionStages = [errorCollectionStages errorCollectionForStage];
    
    matrixSize = size(sensorDataMatrix(2:end,1),1);
    
    % compute relative error
    relativeErrorStages(:,i) = max(errorCollectionStages(:,i) / ( 1/matrixSize * norm(sensorDataMatrix(2:end,1))),...
        errorCollectionStages(:,i) / ( 1/matrixSize * norm(sensorDataMatrix(2:end,2))));  % an array of relative errors for each sample
end


figure
subplot(2,1,1)
boxplot(errorCollectionStages, 'outliersize', 10);
xlabel('Stage');
ylabel('Absolute error');

hold on

subplot(2,1,2)
boxplot(relativeErrorStages);
xlabel('Stage');
ylabel('Relative error');

saveas(gcf, ['../Plots\series' num2str(series) '\errorDistributionOfpreSavedErrorCollection.pdf']);
saveas(gcf, ['../Plots\series' num2str(series) '\errorDistributionOfpreSavedErrorCollection.fig']);
saveas(gcf, ['../Plots\series' num2str(series) '\errorDistributionOfpreSavedErrorCollection.eps'], 'epsc');



