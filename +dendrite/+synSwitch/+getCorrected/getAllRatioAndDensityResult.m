function [results] = getAllRatioAndDensityResult()
% GETALLRATIOANDDENSITYRESULT function uses the density and ratio results
% and combines them into a strucutre (bifur (L2/Deep) vs celltype specific
% (l235)). Each feild contains a table with dimenstions
% representing(dataset/layerOrign and celltype)
%% Get the skeletons for dense reconstruction
skel.bifur=apicalTuft.getObjects('bifurcation');
skel.l235=apicalTuft.getObjects('l2vsl3vsl5');

%% Get the uncorrected synapse density and ratios
synDensity.uc.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur,'getSynDensityPerType',[], false);
synDensity.uc.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235,'getSynDensityPerType',[], false, ...
    'mapping');
synRatio.uc.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur,'getSynRatio',[], false);
synRatio.uc.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235,'getSynRatio',[], false, ...
    'mapping');
synDensity.uc=dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synDensity.uc);
synRatio.uc=dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synRatio.uc);

%% Datasets within L2: small datasets containing the main bifurcation
% annotations in L2
[results]=...
    dendrite.synSwitch.getCorrected.smallDatasets(skel,synRatio,synDensity);
%% Datasets with defined L2, L3 and L5 cell types plus L5A and L2MN
% These datasets provide data from both main bifurcation and distal Tuft
% of ADs
[results]=...
    dendrite.synSwitch.getCorrected.LargeDatasets(skel,...
    synRatio,synDensity,results);
end

