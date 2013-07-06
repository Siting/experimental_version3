function[allS] = saveSamplesForLinks(LINK, allS)

% linkIDs = LINK.keys;

for i = 1 : length(LINK)
    sample = [LINK(i).vmax; LINK(i).dmax / LINK(i).numLanes; LINK(i).dc / LINK(i).numLanes];
    allSamples = allS(i);
    allSamples.samples = [allSamples.samples sample];
    allS(i) = allSamples;
end
