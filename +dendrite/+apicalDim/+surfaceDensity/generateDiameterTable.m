function [results] = generateDiameterTable...
    (synCount, dim, pL)
%GENERATEDIAMETERTABLE 
anotType={'bifur','l235'};
for i=1:2
    % Use thisT for the sizes and initializing the result
    thisT=dim.(anotType{i});
    results.(anotType{i})=cell2table(cell(size(thisT)),...
        'VariableNames',thisT.Properties.VariableNames,'RowNames',...
        thisT.Properties.RowNames);
    for d=1:width(thisT)
        for cellType=1:height(thisT)
            % PPC2L5A annotation has empty L2 and L3 fields
            if ~isempty(dim.(anotType{i}){cellType,d}{1})
            % Get the current variables
            curDiam=dim.(anotType{i}){cellType,d}{1};
            curDiam.apicalDiameter=...
                cellfun(@mean,curDiam.apicalDiameter);
            curpL=pL.(anotType{i}){cellType,d}{1};
            curSynCount=synCount.(anotType{i}){cellType,d}{1};
            % Get the table of all the densities for the current
            % annotations
            curTable=join(join(curDiam,curpL),curSynCount);
            % Lateral cylinder area= pi*avg diameter*Height
            curTable.area=pi*(curTable.apicalDiameter.*...
                curTable.pathLengthInMicron);
            curTable.inhDensity=curTable.Shaft./ ...
                curTable.pathLengthInMicron;
            curTable.excDensity=curTable.Spine./ ...
                curTable.pathLengthInMicron;
            curTable.inhSurfDensity=curTable.Shaft./curTable.area;
            curTable.excSurfDensity=curTable.Spine./curTable.area;
            % The combined structure of tables
            results.(anotType{i}){cellType,d}{1}=curTable;
            end
        end
    end
end
end

