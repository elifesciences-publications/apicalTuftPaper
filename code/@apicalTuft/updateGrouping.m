function [obj] = updateGrouping(obj)
% updateGrouping updates the grouping of skeleton annotations based on the
% tree names.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Note: Some annotations have legacy grouping (L2 vs DL) whereas others
% have the groupingVariable table containg L2, L3, L5st and L5tt
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
        disp('The "apicalType" property of the object is empty')
    end
    
    % Intersection, number of trees check
    obj.pairwiseIntersection(table2cell(obj.groupingVariable));
    totalNumTreesInGroups = sum(varfun(@(x)length(x{1}),...
        obj.groupingVariable,'OutputFormat','uniform'));
    if totalNumTreesInGroups ~= obj.numTrees
        warning(...
            'skeleton has additional trees not detected by the apicalType strings');
    end
end
end

