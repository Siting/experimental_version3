function[LINK] = loadLinksSample(LINK, FUNDAMENTAL)

for i = length(LINK) : -1 : 1
    LINK(i).vmax = FUNDAMENTAL(i).vmax;
    LINK(i).dmax = LINK(i).numLanes * FUNDAMENTAL(i).dmax;
    LINK(i).dc = LINK(i).numLanes * FUNDAMENTAL(i).dc;
end