function [outputOfMethod] = applyMethod2ObjectArray...
    (apTuftArray,method, separategroups, createAggregate, ...
    annotationType,varargin)
% Iterate a method of the apicalTuft class over an array of apicalTuft objects
% INPUT:
%       apTuftArray:
%           1xN cell array of apicalTuft objects
%       method:
%           apicalTuft class method. Note that the method should not require
%           any input
%       separategroups:
%           (default: true) logical: separate the result into  groups.
%           controls shape of output
%       createAggregate:
%           (default: true) logical: determines whether to create an
%           aggregate from the results of the method output
%       annotationType:
%           (default: 'both')  For new grouping determines whether
%            to apply the method to 'mappings' or 'dist2soma' or
%            'both'.
%            Ignored in the legacy case.
%       varargin:
%           Additional input to the called "method". Note that this should
%           be in addition to the "treeIndices" input
% OUTPUT:
%        outputOfMethod:
%        MxN or 1xN cell array of method output type

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('separategroups','var') || isempty (separategroups)
    separategroups = true;
end
if ~exist('createAggregate','var') || isempty (createAggregate)
    createAggregate = true;
end
if ~exist('annotationType','var') || isempty (annotationType)
    annotationType = 'both';
end

% Correct the table array which is the output of this function to look like
% the input. Thereby allowing to chain this function
if istable(apTuftArray)
    if ismember('Aggregate', apTuftArray.Properties.VariableNames)
        apTuftArray.Aggregate = [];
    end
    apTuftArray = table2cell(apTuftArray);
end

% Application of method based on the grouping type
if apTuftArray{1}.legacyGrouping
    outputOfMethod = apicalTuft.applyLegacyGrouping...
        (apTuftArray,method, separategroups, createAggregate,varargin{:});
else
    outputOfMethod = apicalTuft.applyNewGrouping...
        (apTuftArray,method, separategroups, createAggregate, ...
        annotationType,varargin{:});
end

end


