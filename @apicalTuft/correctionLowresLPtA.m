function [skel] = correctionLowresLPtA(skel)
%CORRECTIONLOWRESLPTA correct the lowres voxel size by a correction factor
%of ~ 1.5

% Assert dataset identity to LPtA
assert(contains(skel.parameters.experiment.name,...
    '2016-05-26_FD0144-2_v2s2s'),'The dataset is not the LPtA');
% Correction factor = 1.4896, measured by assuming nuclei to be spherical
correctionFactor=1.4896;
% Last highres voxel border is 2767(in WK)+1(node offset)
LowresBorder=2768;
for i=1:length(skel.nodes)
    % Correction factor
    indices=skel.nodes{i}(:,3)>LowresBorder;
    skel.nodes{i}(indices,3)=round(...
        ((skel.nodes{i}(indices,3)-LowresBorder).*correctionFactor)+...
        LowresBorder);
end
end

