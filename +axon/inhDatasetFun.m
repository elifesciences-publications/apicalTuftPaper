function [measure] = inhDatasetFun(fun,layerSpecific)
% This function iterates a function of the skeleton class/apical Tuft subclass over the tracings
% of inhibitory axons from S1, V2, PPC and ACC

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if nargin<2
    layerSpecific=true;
end
if layerSpecific
    measure=cell(2,5);
    for dataset=1:4
        skel=apicalTuft(apicalTuft.nmlName.inhibitoryAxons{dataset});
        
        %Get the specific Measurement
        measure{1,dataset}=skel.(fun)(skel.l2Idx);
        measure{2,dataset}=skel.(fun)(skel.dlIdx);
    end
    
    measure{1,5}=cat(1,measure{1,1:4});
    measure{2,5}=cat(1,measure{2,1:4});
else
    measure=cell(1,5);
    for dataset=1:4
        skel=apicalTuft(apicalTuft.nmlName.inhibitoryAxons{dataset});
        % Get the specific Measurement
        measure{1,dataset}=skel.(fun);
    end
    measure{1,5}=cat(1,measure{1,1:4});
end
end
