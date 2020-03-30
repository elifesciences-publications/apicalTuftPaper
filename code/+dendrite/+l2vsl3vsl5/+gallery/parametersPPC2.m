function [p] = parametersPPC2()
% parametersPPC2 parameters for creating the PPC-2 Gallery of AD
% reconstructions
% Note: rotation matrix results in the Z dimension being the radial
% direction of the cortical depth.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

p.L1 = 165000;
p.Pia = -22500;
p.ylims = [-3e5,0.5e5];
p.somaSize = 1.5e4;
p.outputDir = fullfile(util.dir.getFig(5),'A','Gallery_fullApicals_PPC2');
p.x_width = 2;p.y_width = 4;
% The L1 surface is better for getting the proper rotation matrix for the
% Z-axis of the dataset being the Pia-WM axis.
p.RotMatrix = dendrite.l2vsl3vsl5.gallery.getRotationMatrixPPC2('l1');
p.view = [90 0];p.camRoll = -180;
p.drawMainBifurcationBbox = true;
p.plotHighResBorder = false;
p.correctionLowRes = false;
end

