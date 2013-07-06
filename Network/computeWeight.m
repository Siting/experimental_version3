function[w] = computeWeight(priorPDF, priorWeights, postPDFs)

nominator = priorPDF;

d = priorWeights .* postPDFs;
denominator = sum(d);

w = nominator / denominator;