% Spine fraction in layer 1 and 2 datasets
% Number of axons for text
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
                % Plot histogram/KSdensity
                util.plot.histogramAndKsdensity...
                    (thisCellRatios.Spine,curColor{cType},ylimitsKS);
            end
        end
        % Save
        util.plot.cosmeticsSave(fh,ax,1.8,1.4,outputDir,fname);
        hold off
    end
end


%% For text: number of axons in each group

for l=1:2
    curRatio=synRatio.(layers{l});
    tableOFNumberOFAxons.(layers{l})=array2table(cellfun(@util.table.height,...
        curRatio.Variables));
    tableOFNumberOFAxons.(layers{l})=util.table.copyRVNames...
        (curRatio,tableOFNumberOFAxons.(layers{l}));
    fprintf('For text, number of axons in %s datasets, per group:\n',layers{l})
    disp(tableOFNumberOFAxons.(layers{l}));
end



