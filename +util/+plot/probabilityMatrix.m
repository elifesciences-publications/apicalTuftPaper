function [] = probabilityMatrix(prob,filename)


% Plot probability matrix
imagesc(prob);colormap(flipud(gray));caxis([0 1])
colorbar;
xticks([]);
yticks([]);
daspect([1,1,1]);
saveas(gca,fullfile(util.addDateToFileName(filename)))

end

