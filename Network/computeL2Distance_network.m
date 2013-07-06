function[distances] = computeL2Distance_network(errorMatrix)

distances = [];
for i = 1 : size(errorMatrix,2)
    d = 1 / size(errorMatrix,1) * sqrt(sum(errorMatrix(:,i).^2));
    distances(i) = d;
end
    
