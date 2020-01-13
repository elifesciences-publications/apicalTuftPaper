function [fh,ax] = plotCorrelationWithSynDensity(feature,outputFolder)
%% Also plot correlation between synaptic density/ratios and the somatic 
% depth
results = dendrite.synSwitch.getCorrected.getAllRatioAndDensityResult;
resultsL5 = results.l235.mainBifurcation([3,5])';
%% Plot
% Get corrected shaft ratio for L5tt and uncorrected shaft ratio for
% first row is uncorrected (L5tt) vs second row of each results is
% corrected (L5st)
curVars={'Shaft_Ratio','Shaft_Density','Spine_Density'};
indexCorrection = [1,2];

for i=1:3
    fname=['CorrelationL5_',curVars{i}];
    fh{i}=figure('Name',fname);ax{i}=gca;
    fullNameForText=fullfile(outputFolder,[fname,'.txt']);
    curMeasure= cell(1,2);
    
    % Concatenate soma diameter with the shaft,spine density/fraction
    for l5=1:2
        if isrow(feature{l5})
            feature{l5} = feature{l5}';
        end
        curMeasure{l5} = [feature{l5},...
            resultsL5{l5}.(curVars{i})(:,indexCorrection(l5))];
    end
    
    % Plot with scatter with linear fit
    util.plot.correlation(curMeasure,{util.plot.getColors().l5color,...
        util.plot.getColors().l5Acolor},...
        [],10,fullNameForText);
    util.plot.addLinearFit(curMeasure,true,...
        fullNameForText);
end
end

