function [unionBbox] = bboxUnion...
    (bboxArray,minSideOne)
%BBOXUNION The bbox created by combining all bounding boxes
if  ~exist('minSideOne','var') || isempty(minSideOne)
    minSideOne=false;
end
if isstruct(bboxArray)
    % Specific for fixing the bounsing boxes of ceonnected component output
    bboxArray=struct2cell(bboxArray);
    bboxArray=cellfun(@(x) reshape(x',3,2),bboxArray,...
        'UniformOutput',false);
    bboxArray=cellfun(@(x) [ceil(x(:,1)) floor(x(:,1)+x(:,2))],...
        bboxArray,'UniformOutput',false);
end
bboxArray=cat(1,bboxArray{:});
assert(all(bboxArray(:)>0),'Bboxes have negative nodes');

if minSideOne
    minSide=[1;1;1];
else
    minSide=min(reshape(bboxArray(:,1),3,[]),[],2);
end
maxSide=max(reshape(bboxArray(:,2),3,[]),[],2);
unionBbox=[minSide,maxSide];
end

