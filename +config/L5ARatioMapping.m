function [prop] = L5ARatioMapping()
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop.outputDir=fullfile(util.dir.getAnnotation,'L5ARatioMapping');
prop.apicalType={'axon'};
prop.syn={'spineSingle','shaft','spineDouble','spineNeck'}';
prop.synExclusion='unsure';
prop.synGroups={{2,3,4}'}';
prop.synLabel={'Spine','Shaft'}';
prop.seed='seed';
prop.legacyGrouping=false;

end

