%% Fig. 7A and Figure Supplement 1A: Synaptic input maps
% Note: This script just generates the skeletons which should be saved and imported
% into illustrator for arrangement into the figure panel.

% Author: Jan Odenthal <jan.odenthal@brain.mpg.de>
util.clearAll
allDendrites = dendrite.wholeApical.mergeBifurcation_WholeApical(4);
l235 = apicalTuft.getObjects('l2vsl3vsl5',[],true);

%% Convert all annotations into z axis being pia distance (y = 0, pia)
allDendConverted = apicalTuft.applyMethod2ObjectArray...
    (allDendrites,'convert2PiaCoord',false,false);
l235Converted = apicalTuft.applyMethod2ObjectArray...
    (l235,'convert2PiaCoord',false,false,'both');
%% Plot data
% Note: These variables are modified by the plotting functions below. Make
% sure to zero them before running the plots
shiftFactorDeep = 0;
shiftFactorL2 = 0;
shiftFactorL3 = 0;
shiftFactorL5 = 0;
Figure7.SupplA.plotDense(allDendConverted.S1);
Figure7.SupplA.plotDense(allDendConverted.V2);
Figure7.SupplA.plotDense(allDendConverted.PPC);
Figure7.SupplA.plotDense(allDendConverted.ACC);
% The LPtA dataset is also used in Fig. 7A
Figure7.SupplA.plotDense2(l235Converted.LPtA);
Figure7.SupplA.plotDense2(l235Converted.PPC2);
