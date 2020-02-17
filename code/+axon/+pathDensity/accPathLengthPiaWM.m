pathLength_L2=zeros(size(bboxCell));
pathLength_dl=zeros(size(bboxCell));
ind_pathLength_l2=cell(size(bboxCell));
ind_pathLength_dl=cell(size(bboxCell));
depths=linspace(240,85,31);
parfor bb=1:length(bboxCell)
    bboxCell{bb}(bboxCell{bb}<1)=1;
    skelRestricted2bbox=skel_trimmed.restrictToBBox(bboxCell{bb},[]);
    
    ind_pathLength_l2{1,bb}=[repmat(depths(bb),size(l2axons)),....
        skelRestricted2bbox.pathLength(l2axons,skel.scale/1000)];
    ind_pathLength_dl{1,bb}=[repmat(depths(bb),size(deepaxons)),...
        skelRestricted2bbox.pathLength(deepaxons,skel.scale/1000)];
end
clf
hold on
cellfun(@(x)use.scatter(x,[0 0 0]),ind_pathLength_l2);
cellfun(@(x)use.scatter(x,dlcolor),ind_pathLength_dl);
set(gca,'YDir','reverse')

xlabel('pathlength[um]')
ylabel('depth from pia')
sumL2=cellfun(@(x)sum(x,1),ind_pathLength_l2,'UniformOutput',false);
sumdl=cellfun(@(x)sum(x,1),ind_pathLength_dl,'UniformOutput',false);
sumL2=cat(1,sumL2{:});
sumdl=cat(1,sumdl{:});
plot(sumL2(:,2),depths,'Color',[0 0 0]);
plot(sumdl(:,2),depths,'Color',dlcolor);
hold off