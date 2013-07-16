% study rejected samples by stages
clear all
clc

series = 15;
studyStages = [3; 5; 7];
studyLinks = 1;
numSamplesStudied = 40;

% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y');
stagesString = [];
for i = 1 : length(studyStages)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i))]];
end

for link = 1 : length(studyLinks)    % iterate through links
    
    i = studyLinks(link);
    
    for stage = 1 : length(studyStages)
        
        % load accepted & rejected samples
        load(['.\ResultCollection\series' num2str(series) '\-acceptedPop-stage-'...
            num2str(studyStages(stage)) '.mat']);
        load(['.\ResultCollection\series' num2str(series) '\-rejectedPop-stage-'...
            num2str(studyStages(stage)) '.mat']);
        numRejectedSamples = size(REJECTED_POP(i).samples,2);
        if numSamplesStudied > numRejectedSamples
            numSamplesStudied = numRejectedSamples;
        end
        
        for sample = 1 : numSamplesStudied     % iterate through samples
            % extract sample info
            sample_vmax = REJECTED_POP(i).samples(1,sample);
            sample_dmax = REJECTED_POP(i).samples(2,sample);
            sample_dc = REJECTED_POP(i).samples(3,sample);
            % start a figure for link (i)
            figure(i * stage)
            densityPoints = 0 : 0.1 : sample_dmax;
            f = Q(densityPoints, sample_vmax, sample_dmax, sample_dc);
            h(1) = plot(densityPoints,f, col(2));
            hold on
        end
        
        for sample = 1 : numSamplesStudied     % iterate through samples
            % extract sample info
            sample_vmax = ACCEPTED_POP(i).samples(1,sample);
            sample_dmax = ACCEPTED_POP(i).samples(2,sample);
            sample_dc = ACCEPTED_POP(i).samples(3,sample);
            % start a figure for link (i)
            figure(i * stage)
            densityPoints = 1 : 0.1 : sample_dmax;
            f = Q(densityPoints, sample_vmax, sample_dmax, sample_dc);
            h(2) = plot(densityPoints,f, col(1));  % !!!! only 2 colors
            hold on
        end
        
        title([num2str(numSamplesStudied) ' fundamental diagrams of accepted and rejected samples from stage '...
            num2str(studyStages(stage)) ' of link ' num2str(i)]);
        legend(h, 'rejected', 'accepted');
        xlabel('\rho');
        ylabel('q');
        saveas(gcf, ['../Plots\series' num2str(series) '\acceptedVsRejectedFuns_link_' num2str(i) '_stage_' num2str(stage) '.pdf']);
        saveas(gcf, ['../Plots\series' num2str(series) '\acceptedVsRejectedFuns_link_' num2str(i) '_stage_' num2str(stage) '.fig']);
        saveas(gcf, ['../Plots\series' num2str(series) '\acceptedVsRejectedFuns_link_' num2str(i) '_stage_' num2str(stage) '.eps'], 'epsc');
        
    end
    
end