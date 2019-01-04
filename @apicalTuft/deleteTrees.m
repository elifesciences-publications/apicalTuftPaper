function obj = deleteTrees(obj, varargin)
% Calls the deleteTrees method of skeleton class and then updates the apical type index
% INPUT varargin:
%       treeIndices: [Nx1] int or [Nx1] logical
%           Array with linear or logical indices of trees to delete.
%       complement: logical (default: false)
%           the complement set of trees to treeIndices would be deleted if
%           true

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
obj=deleteTrees@skeleton(obj,varargin{:});
obj=obj.updateGrouping;    
end

