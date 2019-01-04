config()

for dataset=1:4
    skel=skeleton(info.(names(dataset)).tenUm.nmlName);
    skel_trimmed=skel.getBackBone ([],info.(names(dataset)).tenUm.fixedEnding);
    
    skel_trimmed.write(['apicalDimMeasurement_',skel.filename]);
end