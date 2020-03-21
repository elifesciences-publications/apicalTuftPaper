function [obj] = setDatasetProperties(obj)
% Adjust the dataset setting invloving the distance from pia and L1 border
% location

% Author: Ali Karimi<ali.karimi@brain.mpg.de>
% Used in: Figure 3C, Suppl. Fig 7
% correction(1,:)= distance from pia as dimPiaWM = 0 in microns, correction(2,:)=
% multiply the coord with this, sets the increasing(positive) or decreasing
% (negative) coordinate direction

% Not: distnace to pia was adjusted for each dataset to minimize the effect
% of binning the data for Fig.3. 
% rigid transformation to make the y axis equal to distance from soma

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

I = eye(3);
I_yNeg = bsxfun(@times,[1,-1,1],I);
I_ZReplacedWithY = I([1,3,2]',:);
countNrofDatasets = 0;
if contains(obj.dataset,'S1')
    countNrofDatasets = countNrofDatasets+1;
        obj.datasetProperties = struct('dimPiaWM', 2,...
            'correction',[0 197 0;I_yNeg],... 
            'highResBorder',[],...
            'L1BorderInPixel',8833,'bbox',[1,9344;1,6528;1,7808]);
elseif contains(obj.dataset,'V2')
        countNrofDatasets = countNrofDatasets+1;
        obj.datasetProperties = struct('dimPiaWM', 2,...
            'correction',[0 202.5 0;I],... 
            'highResBorder',[],...
            'L1BorderInPixel',-1708,'bbox',[1,7168;1,10240;1,5120]);
elseif contains(obj.dataset,'PPC') && ~contains(obj.dataset,'PPC2')
        countNrofDatasets = countNrofDatasets+1;
        obj.datasetProperties = struct('dimPiaWM', 2,...
            'correction',[0 156 0;I],... 
            'highResBorder',[],...
            'L1BorderInPixel',-1333,'bbox',[1,12032;1,12032;1,4864]);
elseif contains(obj.dataset,'PPC2')
        countNrofDatasets = countNrofDatasets+1;
        obj.datasetProperties = struct('dimPiaWM', 2,...
            'correction',[0 0 0;I],...
            'highResBorder',[],...
            'L1BorderInPixel',13000,'bbox',[1,25881;1,55373;1,13229]);
elseif contains(obj.dataset,'ACC')
        countNrofDatasets = countNrofDatasets+1;
        obj.datasetProperties = struct('dimPiaWM', 2,...
            'correction',[0 263 0;I_yNeg],... 
            'highResBorder',[],...
            'L1BorderInPixel',7300,'bbox',[1,9216;1,14336;1,3328]);
elseif contains(obj.dataset,'LPtA')
        countNrofDatasets = countNrofDatasets+1;
        obj.datasetProperties = struct('dimPiaWM', 3,...
            'correction',[0 16.9 0;I_ZReplacedWithY],... % 17, 100 nm to make sure small bits don't end up in second bin
            'highResBorder',99940,... %  (2768*30+correction*1000)
            'L1BorderInPixel',4820,'bbox',[16001,29000;16001,26242;1,2767]);
else
        disp('datasetProperties setting failed, no dataset information present!')
end
    assert(countNrofDatasets == 1);
end

