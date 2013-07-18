% study rejected samples by stages
clear all
clc

series = 15;
studyStages = [0;1;3;5;7];
studyLinks = 1;
configID = 41;


% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y');
stagesString = ['stage 0'];
for i = 1 : (length(studyStages)-1)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i+1))]];
end

fileName = (['.\Configurations\fundamental_setting\FUN_CONFIG-' num2str(configID) '.csv']);
fid=fopen(fileName);
funForLinks=textscan(fid,'%d %f %f %f %f %f %f','delimiter',',','headerlines',1);
vmax_mean = funForLinks{2};
dmax_mean = funForLinks{3};
dc_mean = funForLinks{4};
fclose(fid);
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);


for link = 1 : length(studyLinks)    % iterate through links
    
    i = studyLinks(link);

    for j = 1 : length(studyStages)
        
        stage = studyStages(j);
        
        if stage == 0
            figure(i)
            densityPoints = 1 : 0.1 : dmax_mean(i);
            f = Q(densityPoints, vmax_mean(i), dmax_mean(i), dc_mean(i));
            h(stage+1) = plot(densityPoints,f, col(stage+1));
            hold on
        else
                       
            % extract sample info
            sample_vmax = meanForRounds(1, i, stage);
            sample_dmax = meanForRounds(2, i, stage);
            sample_dc = meanForRounds(3, i, stage);

            % start a figure for link (i)
            figure(i)
            densityPoints = 0 : 0.1 : sample_dmax;
            f = Q(densityPoints, sample_vmax, sample_dmax, sample_dc);
            h(j) = plot(densityPoints,f, col(j));
            hold on
        end
    end

    title(['Fundamental diagrams of prior assumption and mean from stages'...
        ' of link ' num2str(i)]);
    legend(h, stagesString);
    xlabel('\rho');
    ylabel('q');
    saveas(gcf, ['../Plots\series' num2str(series) '\priorVsMeanStagesFuns_link_' num2str(i) '.pdf']);
    saveas(gcf, ['../Plots\series' num2str(series) '\priorVsMeanStagesFuns_link_' num2str(i) '.fig']);
    saveas(gcf, ['../Plots\series' num2str(series) '\priorVsMeanStagesFuns_link_' num2str(i) '.eps'], 'epsc');
end