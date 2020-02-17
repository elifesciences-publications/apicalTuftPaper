util.clearAll;
l235=apicalTuft.getObjects('l2vsl3vsl5');
bifurcation=apicalTuft.getObjects('bifurcation');
wholeApical=apicalTuft.getObjects('wholeApical');
allDendrites=[bifurcation,wholeApical,l235];
coords=cell(1,10);
for i=1:length(allDendrites)
    allDendrites{i}=allDendrites{i}.deleteNonUniqueNodeCoord;
end
% Write out cleaned up annotations
for i=1:length(allDendrites)
    allDendrites{i}.write;
end