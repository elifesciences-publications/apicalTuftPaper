function [obj] = updateGrouping(obj)
%UPDATEGROUPING creates groupingVariable table or just updates L2, DL
% groups
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if obj.legacyGrouping
    obj = obj.updateL2DLIdx;
else
    obj.groupingVariable = array2table(num2cell(zeros(1,length(obj.apicalType))),...
        'VariableNames', obj.apicalType);
    if ~isempty(obj.apicalType)
        for i = 1:length(obj.apicalType)
            obj.groupingVariable.(obj.apicalType{i}) = ...
                {obj.getTreeWithName(obj.apicalType{i},'first')};
        end
    else
        disp('no tags for layer 2 and deep layer defined')
    end
    
    % Intersection, number of trees check
    obj.pairwiseIntersection(table2cell(obj.groupingVariable));
    totalNumTreesInGroups = sum(varfun(@(x)length(x{1}),...
        obj.groupingVariable,'OutputFormat','uniform'));
    if totalNumTreesInGroups ~ = obj.numTrees
        warning(...
            'skeleton has additional trees not detected by the apicalType strings');
    end
end
end

