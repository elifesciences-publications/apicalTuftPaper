util.clearAll
allDendrites=dendrite.wholeApical.mergeBifurcation_WholeApical(4);
l235=apicalTuft.getObjects('l2vsl3vsl5',[],true);

% Convert all annotations into z axis being pia distance (y=0, pia)
allDendConverted=apicalTuft.applyMethod2ObjectArray...
    (allDendrites,'convert2PiaCoord',false,false);
l235Converted=apicalTuft.applyMethod2ObjectArray...
    (l235,'convert2PiaCoord',false,false,'both');

shiftFactorDeep=0;
shiftFactorL2=0;
shiftFactorL3=0;
shiftFactorL5=0;
Figure3.SupplA.plotDense(allDendConverted.S1);
Figure3.SupplA.plotDense(allDendConverted.V2);
Figure3.SupplA.plotDense(allDendConverted.PPC);
Figure3.SupplA.plotDense(allDendConverted.ACC);
Figure3.SupplA.plotDense2(l235Converted.LPtA);
Figure3.SupplA.plotDense2(l235Converted.PPC2);

disp('Save the plots as .svg and manually arrange them in an editing software (e.g. in Adobe Illustrator)');