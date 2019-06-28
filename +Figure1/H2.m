% TODO: Fix for L2vsL3vsL5
% Spine targeting ratio of axons in layer 1 (LPtA dataset)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig1,'H');
util.mkdir(outputDir)
apTuft=apicalTuft.getObjects('spineRatioMappingL1');
% The excitatory and inhibitory ratio for axons in LPtA dataset in L1

synRatio=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatioCell=synRatio.Variables;
disp('Outliers:')
% Display excitatory axons which have a spine specificity of <.5
for i=1:3
    disp(i)
    disp (synRatioCell{i,1}((synRatioCell{i,1}.Spine<.5),:));
    disp(i)
    % Display inhibitory axons which have a spine specificity of >.5
    disp (synRatioCell{i,2}((synRatioCell{i,2}.Spine>.5),:));
    disp(i)
end
%% Plot
fh = figure; ax = gca;
spineRatio.layer2=[synRatioCell{1,1}.Spine;synRatioCell{1,2}.Spine];
spineRatio.deep=[synRatioCell{2,1}.Spine;synRatioCell{2,2}.Spine];
hold on
yyaxis (ax,'left')
histogram(spineRatio.layer2,...
    0:0.1:1,'FaceColor',[1,1,1],'FaceAlpha',0,'EdgeColor',l2color)
histogram(spineRatio.deep,0:0.1:1,'FaceColor',[1,1,1],...
    'FaceAlpha',0,'EdgeColor',dlcolor)
yyaxis(ax,'right')
% Value of bandwidth (0.0573) was from deep axons. To make the densities
% comparable I used it for calculating both layer 2 and deep densities
util.plot.ksdensity(spineRatio.deep,dlcolor,0.0573);
util.plot.ksdensity(spineRatio.layer2,l2color,0.0573);
hold off
util.plot.cosmeticsSave(fh,ax,8.4,6.4,outputDir,'H2.svg')


% For text: number of axons in each group
tableOFNumberOFAxons=array2table(cellfun(@height,synRatioCell),...
    'VariableNames',synRatio.Properties.VariableNames,...
    'RowNames',synRatio.Properties.RowNames);
disp('For text, number of axons per group and total:')
disp(tableOFNumberOFAxons);

% Histograms for Supplementary Material
fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioCell{1,1}.Spine,...
    l2color)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_layer2ShaftSeeded.svg','off','on')

fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioCell{1,2}.Spine,...
    l2color)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_layer2SpineSeeded.svg','off','on')
fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioCell{2,1}.Spine,...
    dlcolor)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_DeepLayerShaftSeeded.svg','off','on')

fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioCell{2,2}.Spine,...
    dlcolor)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_DeepLayerSpineSeeded.svg','off','on')


%% Debugging by looking at unique synapses
allComments= apicalTuft.applyMethod2ObjectArray(apTuft,'getAllComments',false,false); % only
allUnique=cellfun(@unique,allComments.Variables,'UniformOutput',false);