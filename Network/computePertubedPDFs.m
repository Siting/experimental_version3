function[postPDFs] = computePertubedPDFs(priorPopulation, pop, covMatrix_post)

postPDFs = [];

% iterate through prior samples
for i = 1 : size(priorPopulation,2)
    % extract the sample info from the prior population
    priorSample = priorPopulation(:,i);
    
    % compute weight based on each prior samples
    if covMatrix_post(1,1) == 0
        p = 1;
    else
        p = mvnpdf(priorSample, pop, covMatrix_post);
    end
    
    % store pdfs
    postPDFs = [postPDFs p];    
end