function [obj] = setDatasetProperties(obj)
% Adjust the dataset setting invloving the distance from pia and L1 border
% location
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

% correction(1,:)= distance from pia as dimPiaWM=0 in microns, correction(2,:)=
% multiply the coord with this, sets the increasing(positive) or decreasing
% (negative) coordinate direction

% Not: distnace to pia was adjusted for each dataset to minimize the effect
% of binning the data for Fig.3. 
% rigid transformation to make the y axis equal to distance from soma
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

I=eye(3);
I_yNeg=bsxfun(@times,[1,-1,1],I);
I_ZReplacedWithY=I([1,3,2]',:);
switch obj.dataset
    case 'S1'
        obj.datasetProperties=struct('dimPiaWM', 2,...
            'correction',[0 200 0;I_yNeg],... %197
            'highResBorder',[],...
            'L1BorderInPixel',8833,'bbox',[1,9344;1,6528;1,7808]);
    case 'V2'
        obj.datasetProperties=struct('dimPiaWM', 2,...
            'correction',[0 200 0;I],... %202.5
            'highResBorder',[],...
            'L1BorderInPixel',-1708,'bbox',[1,7168;1,10240;1,5120]);
    case 'PPC'
        obj.datasetProperties=struct('dimPiaWM', 2,...
            'correction',[0 160 0;I],... %156
            'highResBorder',[],...
            'L1BorderInPixel',-1333,'bbox',[1,12032;1,12032;1,4864]);
    case 'PPC2'
        obj.datasetProperties=struct('dimPiaWM', 2,...
            'correction',[0 0 0;I],...
            'highResBorder',[],...
            'L1BorderInPixel',13000,'bbox',[1,25881;1,55373;1,13229]);
    case 'ACC'
        obj.datasetProperties=struct('dimPiaWM', 2,...
            'correction',[0 260 0;I_yNeg],... % 263
            'highResBorder',[],...
            'L1BorderInPixel',7300,'bbox',[1,9216;1,14336;1,3328]);
    case {'LPtA','LPtAInhibitory','LPtAExcitatory'}
        obj.datasetProperties=struct('dimPiaWM', 3,...
            'correction',[0 20 0;I_ZReplacedWithY],... % 17
            'highResBorder',103070,... % 2 additional pixels for safety (2769*30+correction)
            'L1BorderInPixel',4820,'bbox',[16001,29000;16001,26242;1,2767]);
    otherwise
        disp('datasetProperties setting failed, no dataset information present!')
end

end

