function [obj] = updateL2DLIdx(obj)
% UPDATEL2DLIDX Updates the tree indices for L2 and DL trees
% INPUT:
%       obj: The apicalTuft object
% OUTPUT:
%       obj: ApicalTuft object with the
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~isempty(obj.apicalType)
    obj.l2Idx = obj.getTreeWithName(obj.apicalType{1},'first');
    obj.dlIdx = obj.getTreeWithName(obj.apicalType{2},'first');
    
    obj.l2Idx = obj.l2Idx(:)';
    obj.dlIdx = obj.dlIdx(:)';
    
    if length(obj.names) ~= length(obj.l2Idx)+length(obj.dlIdx)
        warning(...
            'skeleton has additional trees not detected by the apicalType strings');
    end
    assert(isempty(intersect(obj.l2Idx,obj.dlIdx)),...
        'Overlap check between l2 and deep');
else
    disp('Apical tuft object does not have a defined Grouping of trees')
end


end

