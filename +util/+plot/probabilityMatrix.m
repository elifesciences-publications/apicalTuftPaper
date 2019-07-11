function [] = probabilityMatrix(prob,filename)

if ~exist('filename','var') || isempty(filename)
    thisPlot=false;
else
    thisPlot=true;
end
% Plot probability matrix
imagesc(prob);colormap(flipud(gray));caxis([0 1])
colorbar;
xticks([]);
yticks([]);
daspect([1,1,1]);
if thisPlot
saveas(gca,fullfile(util.addDateToFileName(filename)))
end

end

