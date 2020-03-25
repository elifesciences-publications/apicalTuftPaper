nmlName = {'S1_Bifurcations','V2_Bifurcations',...
    'PPC_Bifurcations','ACC_Bifurcations'};

for dataset = 1:4
    skel = apicalTuft(nmlName{dataset});
    skel = skel.setColor([1,0,0]);
    skel.write(['Backbone_',nmlName{dataset},'_1']);
    %Get densities
    skeltrimmed = skel.getBackBone;
    skeltrimmed = skeltrimmed.setColor([0,0,1]);
    skeltrimmed.write(['Backbone_',nmlName{dataset},'_2']);
end