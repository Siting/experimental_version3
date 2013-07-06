function[FUNDAMENTAL] = sampleFUNDA(guessed_FUNDAMENTAL, vmaxVar, dmaxVar, dcVar)

state = true;

while(state)
    
    vmaxMean = guessed_FUNDAMENTAL.vmax;
    dmaxMean = guessed_FUNDAMENTAL.dmax;
    dcMean = guessed_FUNDAMENTAL.dc;
    
    sampleVmax = normrnd(vmaxMean, sqrt(vmaxVar));
    sampleDmax = normrnd(dmaxMean, sqrt(dmaxVar));
    sampleDc = normrnd(dcMean, sqrt(dcVar));
    
    if sampleVmax > 0 && sampleDmax > 0 && sampleDc > 0 &&...
            sampleDmax > sampleDc && sampleVmax <= 100
        FUNDAMENTAL.vmax = sampleVmax;
        FUNDAMENTAL.dmax = sampleDmax;
        FUNDAMENTAL.dc = sampleDc;
        state = false;
    end
end