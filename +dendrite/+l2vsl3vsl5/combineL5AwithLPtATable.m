function [results] = combineL5AwithLPtATable(results)
% COMBINEL5AWITHLPTATABLE combines L5A distal tuft results from 
% PPC2 dataset with LPtA dataset results

results.LPtA{end}=results.PPC2L5ADistal{end};
results=removevars(results,'PPC2L5ADistal');
results.Properties.VariableNames={'mainBifurcation','distalAD'};
end

