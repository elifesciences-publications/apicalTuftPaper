function writeSpinePreferenceExcelSheet()
outputDir = util.dir.getExcelDir(2);
util.mkdir(outputDir);
%% Get ratio and count of synapses

% Remove duplicate of L5tt in L5st spine annotations
synRatio = dendrite.synIdentity.getSynapseMeasure('getSynRatio');
synRatio.L2{'L5A','Spine'}{1} = [];
synRatio.L1{'layer5AApicalDendriteSeeded','Spine'}{1} = [];
% Make the row names shorter
synRatio.L1.Properties.RowNames = {'L2','L3',...
    'L5tt','L5st'};
% Now get synapse count per type as well
synCount = dendrite.synIdentity.getSynapseMeasure('getSynCount');
%% Plot plus write to the excel sheet
layerNames = {'L1','L2'};
% Loop over layer origin and the seed type: the type of AD and the spine 
% vs. shaft seed location
for l = 1:2
    L = layerNames{l};
    seedTypes = synRatio.(L).Properties.VariableNames;
    adTypes = synRatio.(L).Properties.RowNames;
    for seedT = 1:length(seedTypes)
        for adT = 1:length(adTypes)
            if ~isempty(synRatio.(L).(seedTypes{seedT}){adT})
                fname = [L,'_', seedTypes{seedT}, adTypes{adT},'Seeded'];
                % Synapse count and ratios tables for excel file
                countTable = synCount.(L).(seedTypes{seedT}){adT};
                ratioTable = synRatio.(L).(seedTypes{seedT}){adT};
                assert(isequal(countTable.treeIndex , ratioTable.treeIndex));
                % Add ratios to the countTable
                countTable.ShaftRatio = ratioTable.Shaft;
                countTable.SpineRatio = ratioTable.Spine;
                % Write excel sheet with counts and ratios
                writetable(countTable, ...
                    fullfile(outputDir,['Fig2B','.xlsx']),'Sheet',fname);
            end
        end
    end
end
end