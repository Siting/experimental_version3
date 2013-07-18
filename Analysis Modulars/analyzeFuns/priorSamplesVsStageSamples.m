% study rejected samples by stages
clear all
clc

series = 15;
studyStages = [0; 1; 3; 5; 7];
studyLinks = 1;
samplingSize = 50;
configID = 41;

% assign line colors & legends
col=str2mat('r', 'g', 'b', 'k', 'y');
stagesString = ['stage 0'];
for i = 1 : (length(studyStages)-1)
    stagesString = [stagesString; ['stage ' num2str(studyStages(i+1))]];
end

% load prior and posterior
fileName = (['.\Configurations\fundamental_setting\FUN_CONFIG-' num2str(configID) '.csv']);
fid=fopen(fileName);
funForLinks=textscan(fid,'%d %f %f %f %f %f %f','delimiter',',','headerlines',1);
vmax_mean = funForLinks{2};
dmax_mean = funForLinks{3};
dc_mean = funForLinks{4};
vmax_var = funForLinks{5};
dmax_var = funForLinks{6};
dc_var = funForLinks{7};
fclose(fid);
load(['.\ResultCollection\series' num2str(series) '\-calibrationResult.mat']);


for link = 1 : length(studyLinks)    % iterate through links
    
    i = studyLinks(link);
    
    % compile all means & vars together    
    means = [vmax_mean(i); dmax_mean(i); dc_mean(i)];
    vars = [vmax_var(i); dmax_var(i); dc_var(i)];    
    for s = 1 : (length(studyStages)-1)
        means = [means meanForRounds(:,i,studyStages(s+1))];
        vars = [vars varForRounds(:,i,studyStages(s+1))];
    end
    
    % start draw samples and plot
    for k = 1 : length(studyStages)
        
        for j = 1 : samplingSize
            sample = normrnd(means(:, k), sqrt(vars(:, k)), 3, 1);
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

    title(['Sampled fundamental diagrams of prior assumption and mean from stages'...
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



