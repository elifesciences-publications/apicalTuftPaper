skel=apicalTuft('LPtA_l2vsl3vsl5');
skelTrimmed=skel.getBackBone;
thisBbox=skelTrimmed.getBbox;
bboxes=util.bbox.divideDatasetIntoSlices(thisBbox,20000/12,3);
for i=1:length(bboxes)
    figure()
    curBbox=round(bboxes{i});
    skelbboxedWO=skelTrimmed.restrictToBBox(curBbox);
    skelbboxedW=skelTrimmed.restrictToBBoxWithInterpolation(curBbox);
    skelTrimmed.plot([],[0,0,1])
    skelbboxedW.plot([],[0,1,0],[],1)
    skelbboxedWO.plot([],[1,0,0])
    % Draw lines indicating edges of bbox
    b=curBbox';
    l1=b;
    l2=b;
    l1(:,2)=b(1,2);
    l2(:,2)=b(2,2);
    util.plot.linePlot3(l1.*skelTrimmed.scale)
    util.plot.linePlot3(l2.*skelTrimmed.scale)
end