function [] = stairs(stairLocations,Y,varargin)
%STAIRS Add a 0 data point to end since the stairs normaly does not plot
%that last data point when used as a histogram like in Fig 3
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

stairLocations = stairLocations(:)';
stairLocations = [stairLocations, stairLocations(end)+...
    mean(diff(stairLocations(:)'))];
stairs(stairLocations,[Y(:)',0],varargin{:});

end

