function [] = probabilityMatrix(prob,filename)

if ~exist('filename','var') || isempty(filename)
    thisPlot=false;
else
    thisPlot=true;
end
fh = figure();ax=gca;
% Plot probability matrix
imagesc(prob);colormap(flipud(gray));caxis([0 1]);
% Image properties
colorbar;
xticks([]);
yticks([]);
daspect([1,1,1]);
if thisPlot
    x_width = 1.7;
    y_width = 1.7;
    util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,[],filename);
end
end

