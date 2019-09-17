function [output] = iterateOverBboxes(input,apfun,...
    separategroups, createAggregate,cellFlag,outputCell)
%ITERATEOVERBBOXES
if ~exist('createAggregate','var') || isempty (createAggregate)
    createAggregate=false;
end
if ~exist('separategroups','var') || isempty (separategroups)
    separategroups=false;
end
if ~exist('cellFlag','var') || isempty (cellFlag)
    cellFlag=false;
end

if cellFlag
    fun=@(annot) apicalTuft.applyMethod2ObjectArray...
        (annot{1},apfun,separategroups, createAggregate,'mapping');
else
    fun=@(annot) apicalTuft.applyMethod2ObjectArray...
        (annot,apfun,separategroups, createAggregate,'mapping');
end
% Make the output a cell as well
if ~exist('outputCell','var') || isempty (outputCell)
    outputCell=false;
end

output=struct('allDend',[],'l235',[]);
% Assert that 
if istable(input.allDend)
    assert(height(input.allDend)==height(input.l235));
    numSlices=height(input.allDend);
else
    assert(length(input.allDend)==length(input.l235));
    numSlices=length(input.allDend);
end
for b=1:numSlices
    cur.allDend=input.allDend(b,:);
    cur.l235=input.l235(b,:);
    curOut=structfun(fun, cur,'UniformOutput',false);
    % Note: tables with 1 row create an error here; Therefore, I decided to
    % convert everything to cell. When you feed back the output of this
    % function to it you should set the cellflag to true
    output.allDend= [output.allDend;{curOut.allDend}];
    output.l235= [output.l235;{curOut.l235}];
end
if outputCell
    output=structfun(@(x) cellfun(@(y) y.Variables,x,'uni',0),output,...
        'UniformOutput',false);
end
end

