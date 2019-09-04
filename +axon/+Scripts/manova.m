apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio=synRatio.Variables;

%% Manova test for the cortical area cortical areas
nrAxons=cellfun(@height,synRatio(:,1:4));
seedT={'L2','Deep'};
for i=1:2
    % Note:
    % The L2 groups within-group sum of squares and cross products matrix 
    % is singular. Therefore, we removed the AIS and Glia groups
    curRatio=synRatio{i,5}{:,[2:7]};
    gIDs=repelem([1,2,3,4],nrAxons(i,:));
    gNames={'S1','V2','PPC','ACC'}';
    cortexArea.(seedT{i})=gNames(gIDs);
    [curResult.d,curResult.p,curResult.stat]=...
        manova1(curRatio,cortexArea.(seedT{i}));
    disp([seedT{i},':']);
    disp(curResult)
    manovaTbl.(seedT{i})=curResult;
end

% Do posthoc anovas to find the significant differences
for var=1:size(curRatio,2)
    [p(var),~,stat{var}]=anova1(curRatio(:,var),cortexArea.Deep);
end