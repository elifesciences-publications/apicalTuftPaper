% Spine fraction in layer 2 datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig1,'SpineInnervationFraction');
util.mkdir(outputDir);
%% fetch the ratio of each postsynaptic type
synRatio=dendrite.synSwitch.getAllSpineRatios;
synRatio.L2{'L5A','Spine'}{1}=[];
synRatio.L1{'layer5AApicalDendriteSeeded','Spine'}{1}=[];
%% Plot the fraction of single spine innervation
layers=fieldnames(synRatio);
seedTypes=synRatio.L1.Properties.VariableNames;
colors={util.plot.getColors().l2vsl3vsl5([1:3,5]),{l2color,dlcolor,l5Acolor}};
ylimitsKS=[0,15];
for l=1:2
    layerRatios=synRatio.(layers{l});
    curColor=colors{l};
    for sType=1:2
        fname=strjoin({layers{l},seedTypes{sType}},'_');
        fh = figure('Name',fname); ax = gca;
        hold on
        for cType=1:height(layerRatios)
            thisCellRatios=layerRatios{cType,sType}{1};
            if ~isempty(thisCellRatios)
            util.plot.histogramAndKsdensity...
                (thisCellRatios.Spine,curColor{cType},ylimitsKS);
            end
        end
        util.plot.cosmeticsSave(fh,ax,10,10,outputDir,fname);
        hold off
    end
end


% For text: number of axons in each group
tableOFNumberOFAxons=array2table(cellfun(@height,...
    [synRatioInhibitoryCell(:,5),synRatioExcitatoryCell(:,4)]),...
    'VariableNames',{'ShaftSeeded','spineSeeded'},...
    'RowNames',{'layer 2', 'Deep'});
disp('For text, number of axons in L2 datasets, per group:')
disp(tableOFNumberOFAxons);


