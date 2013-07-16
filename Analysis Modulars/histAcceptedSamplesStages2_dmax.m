clear all
clc

series = 15;
studyStages = [1;2;3;4;5;6;7];
studyLinks = [1];
cali_configID = 41;
cali_paraID = 41;
simu_configID = 115;
numSamplesStudied = 100;

% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y', 'c', 'm');
stagesString = [];
for i = 1 : length(studyStages)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i))]];
end

for j = 1 : length(studyLinks)
    link = studyLinks(j);
    for i = 1 : length(studyStages)
        stage = studyStages(i);
        load(['.\ResultCollection\series' num2str(series) '\-acceptedPop-stage-' num2str(stage) '.mat']);
        figure(link) 
        [n, xout] = hist(ACCEPTED_POP(link).samples(2,:));
        h(i) = plot(xout, n, col(i));
        hold on
    end  

    xlabel('\rho_{max}');
    title(['stage ' num2str(stage) ' of link ' num2str(link)]);
    legend(h(1:length(studyStages)), stagesString);
    hold off
end

saveas(gcf, ['../Plots\series' num2str(series) '\acceptedSamplesHist2_dmax.pdf']);
saveas(gcf, ['../Plots\series' num2str(series) '\acceptedSamplesHist2_dmax.fig']);
saveas(gcf, ['../Plots\series' num2str(series) '\acceptedSamplesHist2_dmax.eps'], 'epsc');