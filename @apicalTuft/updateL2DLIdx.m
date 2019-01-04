function [obj] = updateL2DLIdx(obj)
%UPDATEL2DLIDX Updates the indices of layer 2 and deep annotations
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~isempty(obj.apicalType)
    obj.l2Idx=obj.getTreeWithName(obj.apicalType{1},'first');
    obj.dlIdx=obj.getTreeWithName(obj.apicalType{2},'first');
    obj.l2Idx=obj.l2Idx(:)';
    obj.dlIdx=obj.dlIdx(:)';
    if length(obj.names)~=length(obj.l2Idx)+length(obj.dlIdx)
        warning(...
            'skeleton has additional trees not detected by the apicalType strings');
    end
    assert(isempty(intersect(obj.l2Idx,obj.dlIdx)),...
        'Overlap check between l2 and deep');
else
    disp('no tags for layer 2 and deep layer defined')
end


end

