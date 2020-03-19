function [ apicalDiameter,idx2keep ] = getApicalDiameter...
    (skel,treeIndices )
% GETAPICALDIAMETER reads diameter info from the annotations which have the
% dimater in comments either as the number only string or with a location
% prefix examples: '0.3' and 'exit 1.1'

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
apicalDiameter = cell(length(treeIndices),1);
idx2keep = cell(length(treeIndices),1);
for tr = 1:length(treeIndices)
    % Get all the comments, these include comments with a string or without
    % one. The string usually notes the special location such as
    % bifurcation
    treeId = treeIndices(tr);
    curComment = {skel.nodesAsStruct{treeId}.comment}';
    curComment = curComment(~cellfun(@isempty,curComment));
    % Get the comments which contain only the diameter such as: 0.1
    cWithOutString = cellfun(@(x) ...
        all(ismember(x, '0123456789+-.eEdD')),curComment);
    dimWithoutString = cellfun(@str2double,...
        curComment(cWithOutString));
    % Get the diameter from comments which also have string such as:
    %   end 0.1
    dimWithString = cellfun(@(x) regexp(x,'\w* (\d*\.?\d*)','tokens'),...
        curComment(~cWithOutString),'UniformOutput',false);
    % Get the nonempty strings
    idxNonEmpty = cellfun(@(x) ~isempty(x),dimWithString);
    dimWithString = dimWithString(idxNonEmpty);
    dimWithString = cellfun(@(x) str2double(x{1}),dimWithString);
    % concatenate the two diameter vectors
    apicalDiameter{tr} = [dimWithoutString;dimWithString];
    assert(all(~isnan(apicalDiameter{tr})),...
        'Nans exist in the diameter possibly caused by strings with spaces')
end
% Use treename as the identifier
treeIndex = skel.getTreeIdentifier(treeIndices);
apicalDiameter = table(treeIndex,apicalDiameter);
end

