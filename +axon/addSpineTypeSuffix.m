function [apicalLayer2,apicalDeepLayer,otherDendrites] = addSpineTypeSuffix(spineType)
%ADDSPINETYPESUFFIX: Adds the four different type of suffix signifying the
%type of spine synapse: Apical vs other dendrites.
%Author: Ali Karimi <ali.karimi@brain.mpg.de>
spineTypeWithSuffix=[spineType+" shft";spineType+" no src";...
    spineType+" apcl l2";spineType+" apcl dp"];
otherDendrites=spineTypeWithSuffix(1:2,:);
otherDendrites=otherDendrites(:)';
apicalLayer2=spineTypeWithSuffix(3,:);
apicalDeepLayer=spineTypeWithSuffix(4,:);

end

