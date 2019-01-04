skel{1}=apicalTuft('L2_bifurcation','L2bifurcation');
skel{2}=apicalTuft('L3_bifurcation','L3bifurcation');
skel{3}=apicalTuft('L5_bifurcation','L5bifurcation');
% Remove all groupings
% skel=apicalTuft.applyMethod2ObjectArray...
%    (skel,'removeAllGrouping',false,false);
% first delete all the additional trees in each annotation
% this would overwrite the older version

% skel=table2cell(skel);
% for i=1:3
%     skel{i}=skel{i}.deleteTrees([skel{1,i}.l2Idx;skel{i}.dlIdx],true);
%     skel{i}.write;
% end

%% Loop over skeleton and apical type to get their indices for soma
% distance(dl) and bifurcation(l2) tracings
for i=1:3
    for j=1:2
        fun=@(tr) regexp(tr,[(skel{i}.apicalType{j}),'(\d*)'],'tokens');
        if j==1
            curTreeOrder=fun(skel{i}.names(skel{i}.l2Idx));
        else
            curTreeOrder=fun(skel{i}.names(skel{i}.dlIdx));
        end
        assert(length(curTreeOrder)==10);
        % Get the reverse of the permutation array
        curTreeOrder=cellfun(@(x)str2double(x{1}{1}),curTreeOrder);
        curTreeOrder(curTreeOrder) = 1:length(curTreeOrder);
        treeOrder{i,j}=curTreeOrder;
        clear curTreeOrder;
    end
end

% isolate each tree group and put them into separate cell arrays
% Then reorder them to have matching name orders
for i=1:3
    bifurcation{i}=skel{i}.deleteTrees(skel{i}.l2Idx,true);
    bifurcation{i}=bifurcation{i}.reorderTrees(treeOrder{i,1});
    dist2Soma{i}=skel{i}.deleteTrees(skel{i}.dlIdx,true);
    dist2Soma{i}=dist2Soma{i}.reorderTrees(treeOrder{i,2});
    disp(bifurcation{i}.names);
    disp(dist2Soma{i}.names);
end
%%  Update the tree names and combine all annotations into 1 skeleton
names={'layer2ApicalDendrite','layer3ApicalDendrite',...
    'layer5ApicalDendrite'};
signal={'mapping','dist2soma'};
newStringInhRatio=cellfun(@(x) [x,'_',signal{1}],names,...
    'UniformOutput',false);
newStringDist2soma=cellfun(@(x) [x,'_',signal{2}],names,...
    'UniformOutput',false);
for i=1:3
    newString.layer2=newStringInhRatio{i};
    newString.deep=newStringDist2soma{i};
    bifurUpdated{i}=bifurcation{i}. ...
        reformatApicalTreeNames([],newString,'replace');
    dist2SomaUpdated{i}=dist2Soma{i}. ...
        reformatApicalTreeNames([],newString,'replace');
end
combined{1}=skeleton.fromCellArray(bifurUpdated);
combined{2}=skeleton.fromCellArray(dist2SomaUpdated);
allSkel=skeleton.fromCellArray(combined);
%% cleanup comments
cleanComments=apicalTuft.removeGroupingBifurcation(allSkel);
cleanComments=cleanComments{1};
cleanComments=cleanComments.reformatSynComments([],...
    {'Shaft','spineSingleInnervated','spineDoubleInnervated','spineNeck'},...
    'replace');
cleanComments=cleanComments.replaceCommentWithIdx([],cleanComments.getUnsureIdx,...
        'unsureSynapse',[],'complete');
cleanComments.write('PPC2_bifurcation')