function[LINK] = updateAllLinks(LINK,deltaT,page,ensemble)

% linkIds = LINK.keys;

for i = 1 : length(LINK)  
%     link = LINK(linkIds{i});
    dLinkUpdate = CTM(LINK(i).densityResult(:,ensemble,page-1),...
        LINK(i).leftFlux,LINK(i).rightFlux,deltaT,LINK(i).deltaX,...
        LINK(i).vmax,LINK(i).dmax,LINK(i).dc);
    LINK(i).densityResult(:,ensemble,page) = dLinkUpdate; 
%     LINK(linkIds{i}) = link;
end