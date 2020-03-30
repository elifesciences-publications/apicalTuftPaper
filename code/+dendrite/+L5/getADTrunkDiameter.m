function [diameter] = getADTrunkDiameter(skel,treeNames)
% GETADTRUNKDIAMETER get the diameter of AD trunk from annotations (ellipse
% estimation).

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

diameter = table(zeros(size(treeNames(:))),...
    'RowNames',treeNames, 'VariableNames',{'ADTrunkDiameter'});
for i = 1:length(treeNames)
    curTreeNames = ...
        arrayfun(@(x) sprintf([treeNames{i},'_%0.2u'],x),1:2,...
        'UniformOutput',false);
    % Get all the diameters of a L5 pyramidal AD Trunk
    curDiameter = ...
        skel.pathLength(skel.getTreeWithName(curTreeNames))./1000;
    assert (length(curDiameter) == 2, 'Two edges per AD trunk')
    % Get the diameter of the circle with equivalent surface area as the
    % ellipse formed by the two axis measurement
    curAvgDiameter = sqrt(prod(curDiameter));
    diameter{i,1} = curAvgDiameter;
end

end

