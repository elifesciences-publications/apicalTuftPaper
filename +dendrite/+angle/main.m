% From Elias's code


for dataset=1:4
    skel=apicalTuft(apicalTuft.config.bifurcation{dataset});
    skelTrimmed=skel.getBackBone;
    cL2=1;
    cDL=1;
    for tree=1:skel.numTrees
        
        if ismember(tree,skel.l2Idx)
            [AnglesPerPath, Endpoints] = findorigins.FindAllAngles(skelTrimmed, tree);
            [~, AnglesL2{dataset,cL2}] = findorigins.FindOrigin(AnglesPerPath, Endpoints);
            cL2=cL2+1;
        else
            [AnglesPerPath, Endpoints] = findorigins.FindAllAngles(skelTrimmed, tree);
            [~, AnglesDL{dataset,cDL}] = findorigins.FindOrigin(AnglesPerPath, Endpoints);
            cDL=cDL+1;
        end
    end
end


l2=cat(2,AnglesL2{:});
dl=cat(2,AnglesDL{:});
