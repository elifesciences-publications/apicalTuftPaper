function [results] = generateDiameterTable...
    (synCount, dim, pL, skel)
%GENERATEDIAMETERTABLE
anotType={'bifur','l235'};
% correct the L5A synapse count and create an uncorrected variable for
% this surface densities

% Load axon switching fraction
axonSwitchFraction = dendrite.synIdentity.loadSwitchFraction;

% Mimick the shape of the L5A entries in the other variables (LPtA empty entry)
L5stswitchFraction = ...
    {axonSwitchFraction.L2{'L5A',:},{},...
    axonSwitchFraction.L1{'layer5AApicalDendriteSeeded',:}};
for i=1:2
    % Use thisT for the sizes and initializing the result
    thisT=dim.(anotType{i});
    results.(anotType{i})=cell2table(cell(size(thisT)),...
        'VariableNames',thisT.Properties.VariableNames,'RowNames',...
        thisT.Properties.RowNames);
    % Annotated over cell type and region
    for d=1:width(thisT)
        for cellType=1:height(thisT)
            
            % Avoid empty entries in the table
            if ~isempty(dim.(anotType{i}){cellType,d}{1})
                % Get the current variables
                curDiam = dim.(anotType{i}){cellType,d}{1};
                curDiam.apicalDiameter = ...
                    cellfun(@mean,curDiam.apicalDiameter);
                curpL = pL.(anotType{i}){cellType,d}{1};
                isL5st = strcmp(synCount.(anotType{i}).Properties.RowNames{cellType},...
                    'layer5AApicalDendrite_mapping');
                % for L5st
                if ~isL5st
                    curSynCount = synCount.(anotType{i}){cellType,d}{1};
                else
                    curUncorrected = synCount.(anotType{i}){cellType,d}{1};
                    curUncorrected.Properties.VariableNames (2:3)= ...
                        cellfun(@(x) [x,'_','uncorrected'],...
                        curUncorrected.Properties.VariableNames(2:3),'uni',0);
                    L5Atrees = ...
                        skel{1,d}.groupingVariable.layer5AApicalDendrite_mapping{1};
                    
                    curCorrected = ...
                        skel{1,d}.getSynCount(L5Atrees,L5stswitchFraction{d});
                    curCorrected.Properties.VariableNames (2:3)= ...
                        cellfun(@(x) strrep(x,'_corrected',''),...
                        curCorrected.Properties.VariableNames(2:3),'uni',0);
                    curSynCount=join(curCorrected,curUncorrected,'Keys',...
                        'treeIndex');
                end
                % Get the table of all the densities for the current
                % annotations
                curTable=join(join(curDiam,curpL),curSynCount);
                % Lateral cylinder area= pi*avg diameter*Height
                curTable.area = pi*(curTable.apicalDiameter.*...
                    curTable.pathLengthInMicron);
                curTable.inhDensity = curTable.Shaft./ ...
                    curTable.pathLengthInMicron;
                curTable.excDensity = curTable.Spine./ ...
                    curTable.pathLengthInMicron;
                curTable.inhSurfDensity = curTable.Shaft./curTable.area;
                curTable.excSurfDensity = curTable.Spine./curTable.area;
                % add uncorrected densities for L5A (L5st)
                if isL5st
                    curTable.inhSurfDensity_uncorrected = ...
                        curTable.Shaft_uncorrected./curTable.area;
                    curTable.excSurfDensity_uncorrected = ...
                        curTable.Spine_uncorrected./curTable.area;
                end
                % The combined structure of tables
                results.(anotType{i}){cellType,d}{1} = curTable;
            end
        end
    end
end
end

