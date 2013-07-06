clear all
clc

configID = 41;
series = 5;
numStages = 4;
linkID = 5;
accepSampleSize = 100;

allAccepted = [];
for i = 1 : numStages
    load(['.\ResultCollection\series' num2str(series) '\-acceptedPop-stage-' num2str(i) '.mat']);
    allAccepted(:,:,i) = ACCEPTED_POP(linkID).samples(:, 1:accepSampleSize);
end

figure
plot(ones(100,1),allAccepted(2,:,1),'r.');
hold on 
plot(ones(100,1),allAccepted(2,:,4),'b.');
legend('stage1', 'stage4');
title('accepted dmax values of stage 1 and stage 4');
saveas(gcf, ['.\Plots\case' num2str(series) '\link' num2str(linkID) '_dmax.pdf']);