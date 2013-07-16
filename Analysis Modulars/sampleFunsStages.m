% study rejected samples by stages
clear all
clc

series = 15;
studyStages = [1; 3; 5; 7];
studyLinks = 1;
samplingSize = 40;
configID = 41;

% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y');
stagesString = [];
for i = 1 : length(studyStages)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i))]];
end

load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);

for link = 1 : length(studyLinks)    % iterate through links
    
    i = studyLinks(link);
    
    % start draw samples and plot
    for k = 1 : length(studyStages)
        
        for j = 1 : samplingSize
            sample = normrnd(meanForRounds(:, i, studyStages(k)), sqrt(varForRounds(:, i, studyStages(k))), 3, 1);
            if any(sample <= 0) || sample(2) <= sample(3)
                continue
            end
            
            % start a figure for link (i)
            figure(i)
            densityPoints = 0 : 0.1 : sample(2);
            f = Q(densityPoints, sample(1), sample(2), sample(3));
            h(k) = plot(densityPoints,f, col(k));
            hold on
            
        end
    end

    title(['Sampled fundamental diagrams from stages'...
        ' of link ' num2str(i)]);
    legend(h, stagesString);
    xlabel('\rho');
    ylabel('q');
    saveas(gcf, ['../Plots\series' num2str(series) '\sampleFuns_link_'...
        num2str(i) '_stages_' num2str(reshape(studyStages,1,length(studyStages))) '.pdf']);
    saveas(gcf, ['../Plots\series' num2str(series) '\sampleFuns_link_'...
        num2str(i) '_stages_' num2str(reshape(studyStages,1,length(studyStages))) '.fig']);
    saveas(gcf, ['../Plots\series' num2str(series) '\sampleFuns_link_'...
        num2str(i) '_stages_' num2str(reshape(studyStages,1,length(studyStages))) '.eps'], 'epsc');
end