function [results] = combineL5AwithLPtATable(results)
% COMBINEL5AWITHLPTATABLE combines L5A distal tuft results from 
% PPC2 dataset with LPtA dataset results
results.l235.LPtA{end}=results.l235.PPC2L5ADistal{end};
results.l235=removevars(results.l235,'PPC2L5ADistal');
results.l235.Properties.VariableNames={'mainBifurcation','distalAD'};
end

