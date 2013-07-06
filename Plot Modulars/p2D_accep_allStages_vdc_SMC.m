clear all
clc

configID = 41;
series = 5;
numStages = 4;
linkIDs = 1 : 1: 9;

accepSampleSize = 100;

for k = 1 : length(linkIDs)
    linkID = linkIDs(k);
    allAccepted = [];
    for i = 1 : numStages
        load(['.\ResultCollection\series' num2str(series) '\-acceptedPop-stage-' num2str(i) '.mat']);
        allAccepted(:,:,i) = ACCEPTED_POP(linkID).samples(:, 1:accepSampleSize);
    end
    
    figure
    h = [];
    col=str2mat('r', 'g', 'b', 'm', 'y');
    for i = 1 : numStages
        h(i) = scatter(allAccepted(1,:,i), allAccepted(3,:,i), col(i), 'filled');   % accepted
        hold on
    end
    legend([h(1) h(2) h(3) h(4)], 'stage 1','stage 2','stage 3','stage 4');
    xlabel('v_{max}');
    ylabel('\rho_c');
    title(['2D plot of accepted sammples of all stages of link ' num2str(linkID) ' for test ' num2str(series) '.']);
    
    saveas(gcf, ['.\Plots\case' num2str(series) '\link' num2str(linkID) '_2D_allAccepted_vdc.pdf']);
    saveas(gcf, ['.\Plots\case' num2str(series) '\link' num2str(linkID) '_2D_allAccepted_vdc.fig']);
    saveas(gcf, ['.\Plots\case' num2str(series) '\link' num2str(linkID) '_2D_allAccepted_vdc.eps'], 'epsc');
end