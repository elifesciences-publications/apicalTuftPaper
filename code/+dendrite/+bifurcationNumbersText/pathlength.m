% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Pathlength of annotations around the main bifurcation of apical dendrites
% used in Results text

util.clearAll
apTuft = apicalTuft.getObjects('bifurcation');
pathlengthAll = apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getBackBonePathLength',false,true);
PathInMM = sum(pathlengthAll.Aggregate{1}.pathLengthInMicron)/1000;
disp(['Total bifurcation path length in mm: ',num2str(PathInMM)])