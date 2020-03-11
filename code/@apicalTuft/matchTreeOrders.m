function [obj] = matchTreeOrders(obj,objRef)
%MATCHTREEORDERS matches the tree orders for two apicalTuft objects
[~,index] = ismember(objRef.names,obj.names);
obj = obj.reorderTrees(index);
obj = obj.updateGrouping;
assert(isequal(obj.names,objRef.names));
end

