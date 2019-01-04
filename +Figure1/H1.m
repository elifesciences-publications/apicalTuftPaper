% Spine fraction in layer 2 datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig1,'L2SpineInnervationFractionDistribution');
util.mkdir(outputDir);
%% fetch the ratio of each postsynaptic type
% Inhibitory
apTuftInhibitory=apicalTuft.getObjects('inhibitoryAxon','singleSpineLumped');
synRatioInhibitory= apicalTuft. ...
    applyMethod2ObjectArray(apTuftInhibitory,'getSynRatio'); 
synRatioInhibitoryCell=synRatioInhibitory.Variables;
% Display inhibitory axons which have a spine specificity of >.5
disp(synRatioInhibitoryCell{2,5}((synRatioInhibitoryCell{2,5}.SpineSinglePlusApicalSingle>.5),:));
disp (synRatioInhibitoryCell{1,5}((synRatioInhibitoryCell{1,5}.SpineSinglePlusApicalSingle>.5),:));

%% Excitatory
apTuftExcitatory=apicalTuft.getObjects('spineRatioMappingL2');
synRatioExcitatory= apicalTuft. ...
    applyMethod2ObjectArray(apTuftExcitatory,'getSynRatio'); 
synRatioExcitatoryCell=synRatioExcitatory.Variables;

% Display inhibitory axons which have a spine specificity of >.5
disp (synRatioExcitatoryCell{2,4}((synRatioExcitatoryCell{2,4}.Spine<.5),:));
disp (synRatioExcitatoryCell{1,4}((synRatioExcitatoryCell{1,4}.Spine<.5),:));
%% Plot
fh = figure; ax = gca;
spineRatio.layer2=[synRatioInhibitoryCell{1,5}.SpineSinglePlusApicalSingle;...
    synRatioExcitatoryCell{1,4}.Spine];
spineRatio.deep=[synRatioInhibitoryCell{2,5}.SpineSinglePlusApicalSingle;...
    synRatioExcitatoryCell{2,4}.Spine];
hold on
yyaxis (ax,'left')
histogram(spineRatio.layer2,...
    0:0.1:1,'FaceColor',[1,1,1],'FaceAlpha',0,'EdgeColor',l2color)
histogram(spineRatio.deep,0:0.1:1,'FaceColor',[1,1,1],...
    'FaceAlpha',0,'EdgeColor',dlcolor)
yyaxis(ax,'right')
% Value of bandwidth (0.0573) was from deep L1 axons. To make the densities
% comparable I used it for calculating both layer 2 and deep densities
util.plot.ksdensity(spineRatio.deep,dlcolor,0.0573);
util.plot.ksdensity(spineRatio.layer2,l2color,0.0573);
hold off
util.plot.cosmeticsSave(fh,ax,8.4,6.4,outputDir,'H2.svg')


% For text: number of axons in each group
tableOFNumberOFAxons=array2table(cellfun(@height,...
    [synRatioInhibitoryCell(:,5),synRatioExcitatoryCell(:,4)]),...
    'VariableNames',{'ShaftSeeded','spineSeeded'},...
    'RowNames',{'layer 2', 'Deep'});
disp('For text, number of axons in L2 datasets, per group:')
disp(tableOFNumberOFAxons);

% Histograms for Supplementary Material
fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioInhibitoryCell{1,5}. ...
    SpineSinglePlusApicalSingle,l2color)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_layer2ShaftSeeded.svg','off','on')

fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioExcitatoryCell{1,4}. ...
    Spine,l2color)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_layer2SpineSeeded.svg','off','on')

fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioInhibitoryCell{2,5}. ...
    SpineSinglePlusApicalSingle,dlcolor)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_DeepLayerShaftSeeded.svg','off','on')

fh = figure; ax = gca;
util.plot.histogramAndKsdensity(synRatioExcitatoryCell{2,4}. ...
    Spine,dlcolor)
util.plot.cosmeticsSave(fh,ax,7,7,outputDir,'Suppl_DeepLayerSpineSeeded.svg','off','on')


