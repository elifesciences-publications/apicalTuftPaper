function [synCoords]=writeSynCoordinateTextFile( skel,treeIndices,...
    outputFolder,colors, mergeAllSynapses)
%WRITESYNCOORDINATETEXTFILE writes the coordinates to text file in folder:
%                           outputFolderForCoordinates
%INPUT: treeIndices: Index of trees
%       otputFolder: where to write the text files
%       varargin: Refer to getSynIdxComment doc
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

%Setting Default Values
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

if ~exist('outputFolder','var') || isempty(outputFolder)
    outputFolder=pwd;
end

if ~exist('colors','var') || isempty(colors)
    % Shaft, Spine, Inhibitory spine
    colors={'blue','red','blue'};
end
if ~exist('mergeAllSynapses','var') || isempty(mergeAllSynapses)
    mergeAllSynapses=false;
end
%   Get Coordinates
synCoords=skel.getSynCoord(treeIndices);
%   Write to output textFile
counterTree=1;

for tr = treeIndices(:)'
    % delete file in case of merging
    if mergeAllSynapses
        fname=[outputFolder,filesep,colors,'_',skel.names{tr}];
        delete(fname);
        % Don't forget to write the seed coordinate as well
        seedCoord=skel.getNodes(tr,skel.getSeedIdx(tr));
        dlmwrite(fname,seedCoord,'-append','delimiter',' ');
    end
    for syType =2:size(synCoords,2)
        thisSynCoords=synCoords{counterTree,syType}{1};
        if ~isempty(thisSynCoords)
            if mergeAllSynapses
                fname=[outputFolder,filesep,colors,'_',skel.names{tr}];
                dlmwrite(fname,thisSynCoords,'-append','delimiter',' ');
            else
                fname=fullfile(outputFolder,skel.names{tr},...
                    [colors{syType-1},'_',...
                    synCoords.Properties.VariableNames{syType},'_',...
                    skel.names{tr}]);
                dlmwrite(fname,thisSynCoords,' ');
            end
        else
            disp('no syn existent')
        end
    end
    counterTree=counterTree+1;
end
end

