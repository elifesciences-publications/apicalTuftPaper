util.clearAll;
util.setColors;
outputDir = fullfile(util.dir.getFig(2),'SpineInnervationFraction');
util.mkdir(outputDir);
%% Get ratio and count of synapses
synRatio = dendrite.synIdentity.getSynapseMeasure('getSynRatio');
synRatio.L2{'L5A','Spine'}{1} = [];
synRatio.L1{'layer5AApicalDendriteSeeded','Spine'}{1} = [];
synCount = dendrite.synIdentity.getSynapseMeasure('getTotalSynNumber');
% Remove duplicate of L5tt in L5st spine annotations
synCount.L1.Spine{end} = [];
synCount.L2.Spine{end} = [];
synCount_Ind = dendrite.synIdentity.getSynapseMeasure('getSynCount');
curColor = {util.plot.getColors().l2vsl3vsl5([1:3,5]),{l2color,dlcolor,l5Acolor}};
%% Plot plus write to the excel sheet
layerNames = {'L1','L2'};
for l = 1:2
    L = layerNames{l};
    seedTypes = synRatio.(L).Properties.VariableNames;
    adTypes = synRatio.(L).Properties.RowNames;
    for seedT = 1:length(seedTypes)
        for adT = 1:length(adTypes)
            if ~isempty(synRatio.(L).(seedTypes{seedT}){adT})
            fh = figure; ax = gca;
            fname = [L,'region_',seedTypes{seedT},'_seeded_',adTypes{adT}];
            curRatio = synRatio.(L).(seedTypes{seedT}){adT}.Spine;
            curCountTotal = synCount.(L).(seedTypes{seedT}){adT}. ...
                totalSynapseNumber;
            idx = curCountTotal >= 5;
            util.plot.histogramAndKsdensity...
                (curRatio(idx),curColor{l}{adT});
            title(fname); xlabel('Spine innervation fraction');
            yyaxis left;ylabel('Number of axons');
            util.plot.cosmeticsSave(fh,ax,5,5,outputDir,fname);
            % tables for excel file
            countTable = synCount_Ind.(L).(seedTypes{seedT}){adT};
            ratioTable = synRatio.(L).(seedTypes{seedT}){adT};
            assert(isequal(countTable.treeIndex , ratioTable.treeIndex));
            countTable.SpineRatio = ratioTable.Spine;
            countTable.ShaftRatio = ratioTable.Shaft;
            writetable(countTable, ...
                fullfile(outputDir,[fname,'.xlsx']));
            end
        end
    end
end
