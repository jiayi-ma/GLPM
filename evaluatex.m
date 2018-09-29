function [precision, recall, numCorrect] = evaluatex(p,CorrectIndex)


corIndex = find(p);
totalFind = sum(p);
CorrectIndex = CorrectIndex';
correct = intersect(corIndex,CorrectIndex);
%error = setdiff(corIndex,correct);
%miss = setdiff(CorrectIndex,correct);
numCorrect = length(correct);
%[~,numError] = size(error);
%[~,numMiss] = size(miss);
numAnswer = length(CorrectIndex);
precision = numCorrect/totalFind;
recall = numCorrect/numAnswer;
fprintf('Precision: %d/%d=%f\nRecall: %d/%d=%f\n',numCorrect,totalFind,...
    precision,numCorrect,numAnswer,recall);

end

