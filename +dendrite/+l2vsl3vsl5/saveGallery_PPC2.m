function [] = saveGallery_PPC2(apTuft,trIndices,...
    color)
%SAVEGALLERY This function prints the gallery of full dendrite annotations
%within the PPC2 dataset
Zdepth.L1=165000;
Zdepth.Pia=-22500;
ylims=[-3e5,0.5e5];
somaSize=1.2e4;
outputDir=fullfile(util.dir.getFig3,'Gallery_fullApicals_PPC2');
fh=figure;ax=gca;x_width=10;y_width=20;
RotMatrix=dendrite.l2vsl3vsl5.getRotationMatrixPPC2('l1');

for i=1:length(trIndices)
    clf
    tr=trIndices(i);
    hold on
    apTuft.plot(tr,color,[],[],[],[],somaSize,[],RotMatrix);
    daspect([1,1,1]);
    ylim(ylims);zlim([Zdepth.Pia,7e5])
    view([90 0]);camroll(-180);
    % Plot L1 and pia
    plot3([0,0],ylims,repmat(Zdepth.L1,1,2),'--','Color','k');
    plot3([0,0],ylims,repmat(Zdepth.Pia,1,2),'Color','k');
    axis off;
    drawnow;pause(.5)
    hold off
    util.plot.cosmeticsSave(fh,ax,x_width,y_width,...
        outputDir,[apTuft.names{tr},'.svg'],[],[],false);
end
end

