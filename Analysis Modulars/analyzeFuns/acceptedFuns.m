% study rejected samples by stages
clear all
clc

series = 15;
studyStages = [1;3;5;7];
studyLinks = 1;
numSamplesStudied = 40;

% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y');
stagesString = [];
for i = 1 : length(studyStages)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i))]];
end


% plot fundamentals    
for link = 1 : length(studyLinks)    % iterate through links
    
    i = studyLinks(link);
    
    for stage = 1 : length(studyStages)
        
        load(['.\ResultCollection\series' num2str(series) '\-acceptedPop-stage-'...
            num2str(studyStages(stage)) '.mat']);
        
        for sample = 1 : numSamplesStudied     % iterate through samples
            % extract sample info
            sample_vmax = ACCEPTED_POP(i).samples(1,sample);
            sample_dmax = ACCEPTED_POP(i).samples(2,sample);
            sample_dc = ACCEPTED_POP(i).samples(3,sample);
            % start a figure for link (i)
            figure(i)
            densityPoints = 0 : 0.1 : sample_dmax;
            f = Q(densityPoints, sample_vmax, sample_dmax, sample_dc);
            h(stage) = plot(densityPoints,f, col(stage));
            hold on
        end
        
    end

    title([num2str(numSamplesStudied) ' fundamental diagrams of accepted samples from stages '...
        ' of link ' num2str(i)]);
    legend(h(1:length(studyStages)), stagesString);
    xlabel('\rho');
    ylabel('q');
    saveas(gcf, ['../Plots\series' num2str(series) '\acceptedFuns_link_' num2str(i) '.pdf']);
    saveas(gcf, ['../Plots\series' num2str(series) '\acceptedFuns_link_' num2str(i) '.fig']);
    saveas(gcf, ['../Plots\series' num2str(series) '\acceptedFuns_link_' num2str(i) '.eps'], 'epsc');

end