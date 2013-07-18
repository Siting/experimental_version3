function[LINK] = loadLinks_error(linkMap,FUNDAMENTAL, configID, LINK, means, vars)

linkIds = linkMap.keys;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vmax_mean = means(1,:);
dmax_mean = means(2,:);
dc_mean = means(3,:);
vmax_var = vars(1,:);
dmax_var = vars(2,:);
dc_var = vars(3,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%

guessedFUNDAMENTAL = FUNDAMENTAL;

for i = 1 : length(linkIds)
    
    NTlink = linkMap(linkIds{i});
    link = LINK(linkIds{i});
    link.densityResult = [];
    
    guessedFUNDAMENTAL.vmax = vmax_mean(i);
    guessedFUNDAMENTAL.dmax = dmax_mean(i);
    guessedFUNDAMENTAL.dc = dc_mean(i);
    [FUNDAMENTAL] = sampleFUNDA(guessedFUNDAMENTAL, vmax_var(i), dmax_var(i), dc_var(i));
    link.vmax = FUNDAMENTAL.vmax;
    link.dmax = NTlink.numberOfLanes * FUNDAMENTAL.dmax;
    link.dc = NTlink.numberOfLanes * FUNDAMENTAL.dc;
    
    LINK(linkIds{i}) = link;
end