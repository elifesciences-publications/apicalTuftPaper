function [allDendrites] = mergeBifurcation_WholeApical(totalTracingNum)
%MERGEBIFURCATION_WHOLEAPICAL Merges the bifurcation and apical dendrite
% groups
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('totalTracingNum','var') || isempty (totalTracingNum)
    totalTracingNum = 4;
end
% read bifrucation remove the ones used for initialization of whole apical
% dendrites
bifur = apicalTuft.getObjects('bifurcation');
bifurRemoveDuplicates = apicalTuft.deleteDuplicateBifurcations(bifur);
wholeApical = apicalTuft.getObjects('wholeApical');
allDendrites = cell(1,totalTracingNum);
% Merge the bifurcations into the whole apical dendrite annotations
for d = 1:max([length(wholeApical),length(bifurRemoveDuplicates)])
    if d <= length(bifurRemoveDuplicates)
        assert(strcmp(bifurRemoveDuplicates{d}.parameters.experiment.name,...
            wholeApical{d}.parameters.experiment.name));
        allDendrites{d} = wholeApical{d}.mergeSkels(bifurRemoveDuplicates{d});
    else
        allDendrites{d} = wholeApical{d};
    end
end
% Update tree grouping names and then sort trees by names
for i = 1:totalTracingNum
    allDendrites{i} = allDendrites{i}.updateL2DLIdx;
    allDendrites{i} = allDendrites{i}.sortTreesByName;
end
end

