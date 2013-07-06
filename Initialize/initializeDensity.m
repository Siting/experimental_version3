% Initialize Density of Each Link
function[LINK] = initializeDensity(LINK,numEns,CONFIG)

% linkIds = LINK.keys;
initialStateID = CONFIG.initialStateID;

% if there is no file have the initial value assinged, then use arbitrary values 
% if there is file, use the value in the file
if isempty(initialStateID)
    disp('There is no assinged initial state file, use arbitrary values');
    for i = 1 : length(LINK)
        link = LINK(i);
        gamma = 5;
        meanV = link.numLanes * 10;
        dVar = sqrt(gamma) * randn(link.numCells,numEns);
        density(:,:,1) = meanV+dVar;
        link.densityResult(:,:,1) = density(:,:,1);
        LINK(i) = link;
    end
else
    initialStateID = CONFIG.initialStateID;
    fileName = (['.\Configurations\initial_state\' initialStateID '.csv']);
    fid = fopen(fileName);
    initialStateData = textscan(fid,'%d %f %f','delimiter',',','headerlines',1);
    fclose(fid);
    densityMean = initialStateData{2};
    densityVar = initialStateData{3};
    % check if all link has been signed value in the csv file
    
        for i = 1 : length(LINK)
            link = LINK(i);
            meanV = densityMean(i);
            varV = densityVar(i);
            dVar = sqrt(varV) * randn(link.numCells,numEns);
            density = meanV + dVar;
            link.densityResult(:,:,1) = density;
            LINK(i) = link;
        end
end
    