function[postWeightsAverage] = updateWeights(NEW_ACCEPTED_POP, priorWeights, ACCEPTED_POP, configID, linkMap, nodeMap)

global funsOption
global testingSensorIDs

linkIDs = cell2mat(linkMap.keys);
% studyLinks = [nodeMap(nodeID).incomingLinks; nodeMap(nodeID).outgoingLinks];
% linkWithSensor = [];
% for i = 1 : length(studyLinks)
%     if isempty(linkMap(studyLinks(i)).sensors) == 0
%         linkWithSensor = [linkWithSensor studyLinks(i)];
%     end
% end
linkWithSensor = [];
for i = 1 : length(linkIDs)
    if ismember(linkMap(i).sensors, testingSensorIDs)
        linkWithSensor = [linkWithSensor linkIDs(i)];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if funsOption == 2
    fileName = (['.\Configurations\fundamental_setting\FUN_CONFIG-' num2str(configID) '.csv']);
    fid=fopen(fileName);
    funForLinks=textscan(fid,'%d %f %f %f %f %f %f','delimiter',',','headerlines',1);
    vmaxMean = funForLinks{2};
    dmaxMean = funForLinks{3};
    dcMean = funForLinks{4};
    vmaxVar = funForLinks{5};
    dmaxVar = funForLinks{6};
    dcVar = funForLinks{7};
    fclose(fid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%


postWeightsLinks = [];
para_cov = 0;

for j = 1 : length(linkWithSensor)
    postWeights = [];
    i = linkWithSensor(j);
    
    population = NEW_ACCEPTED_POP(linkIDs(i)).samples;
    priorPopulation = ACCEPTED_POP(linkIDs(i)).samples;
    
    % mean and var from assumed distribution
    meanValue_prior = [vmaxMean(i); dmaxMean(i); dcMean(i)];
    covMatrix_prior = [vmaxVar(i) para_cov para_cov;
        para_cov, dmaxVar(i), para_cov;
        para_cov, para_cov, dcVar(i)];
    
    % mean and var from pertubed distribution
    vmax_std = var(population(1,:));
    dmax_std = var(population(2,:));
    dc_std = var(population(3,:));
    covMatrix_post = [vmax_std, para_cov para_cov;
        para_cov, dmax_std, para_cov;
        para_cov, para_cov, dc_std];
    
    
    % iterate through # of samples
    for sample = 1 : size(population,2)
        % extract sample info
        pop = population(:,sample);
        
        % compute pdf of the assumed distribution(multivariate)
        if covMatrix_prior(1,1) == 0
            priorPDF = 1;
        else
            priorPDF = mvnpdf(pop,meanValue_prior,covMatrix_prior);
        end
        
        % compute pdfs of the perturbed distribution
        postPDFs = computePertubedPDFs(priorPopulation, pop, covMatrix_post);
        
        % update weight for the sample
        w = computeWeight(priorPDF, priorWeights, postPDFs);
        
        % store updated weights
        postWeights = [postWeights w];
        
        if mod(sample,100) == 0
            disp(['weight computed for the ' num2str(sample) 'th sample']);
        end
        
    end

    postWeightsLinks = [postWeightsLinks; postWeights];
end

postWeightsAverage = mean(postWeightsLinks,1);