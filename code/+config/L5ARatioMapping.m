function [prop] = L5ARatioMapping()
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop.outputDir = fullfile(util.dir.getAnnotation,'L5ARatioMapping');
prop.apicalType = {'axon'};
prop.syn = {'shaft','spineDouble','spineNeck','spineSingle'}';
prop.synExclusion = 'unsure';
prop.synGroups = {{1:3}'}';
prop.synLabel = {'Shaft','Spine'}';
prop.seed = 'seed';
prop.legacyGrouping = false;

end

