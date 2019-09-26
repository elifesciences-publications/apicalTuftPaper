%% Plot L5A distal soma annotation to add to old annotations
apTuft=apicalTuft.getObjects('l2vsl3vsl5',[],true);
apTuft= util.varfunKeepNames(@(x) x.sortTreesByName,apTuft);
apTuftPruned=apicalTuft('PPC2L5ADist2SomaPruned_l2vsl3vsl5');
apTuftPruned=apTuftPruned.sortTreesByName;
%%
fname='L5A_denseDistalAD';
outputDir=fullfile(util.dir.getFig3,'TheL5ADistalADDense');
fh=figure('Name',fname);ax=gca;
hold on;
p=dendrite.l2vsl3vsl5.gallery.parametersPPC2;
% No overlap between trees
correctionTree=[0:2e5:4e5];
correctionTreeDense=repelem(correctionTree,2);

apTuft.PPC2L5ADistal.plot([],[0,0,0],[], [],...
    [],[],[],[],p.RotMatrix,correctionTreeDense);
apTuft.PPC2L5ADistal.plotSynapses([],[],...
    'theColorMap',[0,1,1;1,0,0],'sphereSize',1.7,...
    'rotationMatrix',p.RotMatrix,'correction',correctionTreeDense)
trIndices = ...
    apTuft.PPC2.groupingVariable.layer5AApicalDendrite_dist2soma{1};
apTuftPruned.plot...
    ([],[0,0,0],[],[],...
    [],[],[],[],p.RotMatrix,correctionTree);
% Set matching limits
zlim([0,1.2e5])
daspect([1,1,1]);
view([0,1,0]);camroll(p.camRoll);
% util.plot.cosmeticsSave(fh,ax,p.x_width,p.y_width,...
%   outputDir,[fname,'.svg'],[],[],false);
print(fh,fullfile(outputDir,...
    fname),'-dsvg');
system('./synPlots.sht');