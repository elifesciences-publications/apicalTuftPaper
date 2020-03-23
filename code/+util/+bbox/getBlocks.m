function [blockBounds,blockLength] = getBlocks(bounds,blocksize,fixTheOrigin)
% getBlocks returns bounds along one dimension given the bounds and the
% block size. The origin can be fixed to 1.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Defaults
if ~exist('fixTheOrigin','var') || isempty(fixTheOrigin)
    fixTheOrigin = false;
end
% if blocksize equals bounds just give back one block
if blocksize == diff(bounds,1,2)+1
    blockBounds{1} = bounds;
    return
end

% By Fixing the origin I mean the following:
% The block bounds are taken from blocks assuming a start point of 1 and 
% step sizes of block size. In case the start and end bounds do not match
% these points additional blocks of size smaller than blocksize are added
if fixTheOrigin
    startIndices = 1:blocksize:bounds(2);
    startIndices = [bounds(1),startIndices(startIndices>bounds(1))];
    endIndices = startIndices(2:end)-1;
else
    startIndices = bounds(1):blocksize:bounds(2);
    endIndices = startIndices(2:end)-1;
end

% The bounds cell array (last one added later)
blockBounds = cell(length(endIndices),1);
for b = 1:length(endIndices)
    blockBounds{b} = [startIndices(b),endIndices(b)];
end

% Add the end block
if endIndices(end) < bounds(2)
    blockBounds{b+1} = [endIndices(end)+1,bounds(2)];
elseif endIndices(end) == bounds(2)
    % do nothing since the last bound matches the actual number
else
    error('endIndices cannot be larger than the original bound')
end

% Also output the length of each individual block length
blockLength = cellfun(@(x)diff(x)+1,blockBounds,'UniformOutput',false);
blockLength = cell2mat(blockLength);
end

