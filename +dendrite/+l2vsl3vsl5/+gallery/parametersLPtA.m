function [p] = parametersLPtA()
%PARAMETERSLPTA 
p.L1=144600;
p.Pia=-17000;
p.ylims=[1e5,4.5e5];
p.somaSize=1.5e4;
p.outputDir=fullfile(util.dir.getFig(3),'Gallery_fullApicals_LPTA');
util.mkdir(p.outputDir);
p.x_width=2;p.y_width=4;
p.RotMatrix=eye(3);
p.view=[90 0];p.camRoll=-180;
p.drawMainBifurcationBbox=false;
p.plotHighResBorder=true;
p.correctionLowRes=true;
end

