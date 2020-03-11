function draw( isosurface,varargin )
%draw This function creates an isosurface plot using the
% patch function
%INPUT: isosurface: the structure output of isosurface function 
%       varargin : controling the properties of the the surface 
%                   color, angle, faceAlpha                   

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

p = inputParser;
defaultColor = [1 0 0]; 
defaultangle = [0,-90];
defaultFaceAlpha = 0.3;
%create parameters setting them to default
addParameter(p,'color',defaultColor);
addParameter(p,'angle',defaultangle);
addParameter(p,'faceAlpha',defaultFaceAlpha);
% Parsing varargin and setting the values
parse(p,varargin{:});
color = p.Results.color;
angle = p.Results.angle;
faceAlpha = p.Results.faceAlpha;


p = patch(isosurface);
p.FaceColor = color;
p.EdgeColor = 'none';
daspect([1 1 1])
view(angle)
axis tight
camlight
lighting gouraud
p.FaceAlpha = faceAlpha;

end

