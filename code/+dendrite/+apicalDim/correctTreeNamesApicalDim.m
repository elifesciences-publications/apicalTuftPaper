%% Change the name of apical Diameter annotations to match 
% the dense input mapping annotations
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

apDim=apicalTuft.getObjects('apicalDiameter');
bifur=apicalTuft.getObjects('bifurcation');

% Use bifurcaiton coordinate to match annotations between apicalDiameter
% and bifurcation input mapping
bifurCoordinates.inh=apicalTuft. ...
    applyMethod2ObjectArray(bifur,'getBifurcationCoord',...
    false,false,[],false);
bifurCoordinates.SomaLoc=apicalTuft. ...
    applyMethod2ObjectArray(apDim,'getBifurcationCoord', ...
    false,false,[],false);
fun=@(x,y) ismember(x,y,'rows');
[~,index]=cellfun(fun,bifurCoordinates.SomaLoc.Variables,...
    bifurCoordinates.inh.Variables,...
    'UniformOutput',false);
% Rename and rewrite
for i=1:4
    apDim{i}.names=bifur{i}.names(index{i});
    apDim{i}.write
end
