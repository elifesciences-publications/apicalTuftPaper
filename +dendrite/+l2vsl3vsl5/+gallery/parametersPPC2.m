function [p] = parametersPPC2()
%CONFIGPPC2 parameters for creating the PPC2 Gallery
p.L1=165000;
p.Pia=-22500;
p.ylims=[-3e5,0.5e5];
p.somaSize=1.5e4;
p.outputDir=fullfile(util.dir.getFig3,'Gallery_fullApicals_PPC2');
p.x_width=2;p.y_width=4;
p.RotMatrix=dendrite.l2vsl3vsl5.gallery.getRotationMatrixPPC2('l1');
p.view=[90 0];p.camRoll=-180;
p.drawMainBifurcationBbox=true;
p.plotHighResBorder=false;
p.correctionLowRes=false;
end

