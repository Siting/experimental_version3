function[POST_ACCEPTED_POP, indexCollection] = sampleFromPreviousPop(ACCEPTED_POP, weights)

indexCollection = [];   % indicating which particle was saved

% iterate through # of prior populations
for p = 1 : length(weights)
    
    % generate random number r which is uniformly distributed on [0,1]
    r = random('unif',0,1);
    weightAccumulated = 0;
    
    % compare the random number r with cdf
    for i = 1 : length(weights)
        weightAccumulated = weightAccumulated + weights(i);
        if weightAccumulated >= r            
            indexCollection = [indexCollection i];
            break
        end
        
    end

end

% extract selected samples
POST_ACCEPTED_POP = extractSelectedSamples(indexCollection, ACCEPTED_POP);