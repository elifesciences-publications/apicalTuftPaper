function [results] = extractInformation(g,fun,variables,ignoreSizeThreshold)
%EXTRACTINFORMATION This function is for working with the table of tables
% generated for Figure 3 analysis
% Return the whole values of a feature if the function is empty
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if ~exist('fun','var') ||isempty(fun) 
    returnRawValues=true;
else
    returnRawValues=false;
end
if ~exist('ignoreSizeThreshold','var')||isempty(ignoreSizeThreshold) 
    ignoreSizeThreshold=false;
end
results=struct();
for apType=1:width(g)
    for depth=1:height(g)
        for var=1:length(variables)
            curT=g{depth,apType}{1};
            if isempty(curT) || all(curT.combinedThresh==0)
                results.(variables{var}){depth,apType}=nan;
            else
                % Here we ignore the size threshhold since we wanted to combine
                % all data as a check for Suppl.Fig3B-D
                if ignoreSizeThreshold
                    curT.combinedThresh=ones(size(curT.combinedThresh));
                end
                % Decide whether to apply a function or return raw values
                if returnRawValues
                    results.(variables{var}){depth,apType}=...
                        curT.(variables{var})(logical(curT.combinedThresh));
                else
                    results.(variables{var}){depth,apType}=...
                        fun(curT.(variables{var})(logical(curT.combinedThresh)));
                end
            end
        end
    end
end
results=struct2table(results);
end

