function writeSphere(coords,diameter,fname,color)
% Writes a set of spheres of diameter at coords in color
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Note: coordinates should be in NM
Surfaces = cell(size(coords,1),1);
for i = 1:size(coords,1)
    % Get unit sphere
    [X,Y,Z] = sphere(10);
    Surfaces{i} = surf2patch(X,Y,Z,'triangles');
    % Scale and translate
    Surfaces{i}.vertices = Surfaces{i}.vertices.*diameter;
    Surfaces{i}.vertices = Surfaces{i}.vertices+repmat(coords(i,1:3),...
        [size(Surfaces{i}.vertices,1),1]);
end
colors = repmat(color,size(Surfaces));
% Write as ply file
Visualization.writePLY(Surfaces,colors,fname);
end

