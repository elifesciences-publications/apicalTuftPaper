function [] = saveGallery(apTuft,trIndices,...
    color,p)
% SAVEGALLERY This function prints the gallery of full dendrite annotations.
% Note: the annotation should be so that the Z-axis is the radial cortical
% axis

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if p.correctionLowRes
    apTuft = apTuft.correctionLowresLPtA;
end
fh = figure; ax = gca;
for i = 1:length(trIndices)
    clf
    tr = trIndices(i);
    hold on
    % Draw the AD
    apTuft.plot(tr,color,[],[],[],[],p.somaSize,[],p.RotMatrix);
    % Correct orientation and limits
    daspect([1,1,1]);
    ylim(p.ylims);zlim([p.Pia,7e5])
    view(p.view);camroll(p.camRoll);
    
    % Plot L1 and pia
    plot3([0,0],p.ylims,repmat(p.L1,1,2),'--','Color','k');
    plot3([0,0],p.ylims,repmat(p.Pia,1,2),'Color','k');
    axis off;
    
    % Draw box around bifurcation (PPC-2 dataset)
    if p.drawMainBifurcationBbox
        bifurCenter = p.RotMatrix * (apTuft.getBifurcationCoord(tr))';
        dendrite.l2vsl3vsl5.gallery.drawSquareAroundPoint(bifurCenter);
    end
    % Plot high-res border (LPtA)
    if p.plotHighResBorder
        % High resolution Y-extent [191080,303480]
        plot3([0,0],p.ylims,[83040,83040],':','Color','k')
    end
    drawnow;pause(.5)
    hold off
    % Save figure
    util.plot.cosmeticsSave(fh,ax,p.x_width,p.y_width,...
        p.outputDir,[apTuft.names{tr},'.svg'],[],[],false);
end
end


