apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio=synRatio.Variables;

%% Manova test for the cortical area cortical areas
nrAxons=cellfun(@height,synRatio(:,1:4));
aggRatios=synRatio(:,5);
seedT={'L2','Deep'};
stat=cell(6,2);p=zeros(6,2);MC=cell(6,2);
for i=1:2
    % Note:
    % The L2 groups within-group sum of squares and cross products matrix
    % is singular. Therefore, we removed the AIS and Glia groups
    curRatio=aggRatios{i}{:,[2:7]};
    gIDs=repelem([1,2,3,4],nrAxons(i,:));
    gNames={'S1','V2','PPC','ACC'}';
    cortexArea.(seedT{i})=gNames(gIDs);
    % Create a matrix plot (correlations with diagonal histograms)
    figure('Name',seedT{i})
    gplotmatrix(curRatio,[],cortexArea.(seedT{i}),'krgb');
    % Manova test with results
    [curResult.d,curResult.p,curResult.stat]=...
        manova1(curRatio,cortexArea.(seedT{i}));
    disp([seedT{i},':']);
    disp(curResult)
    manovaTbl.(seedT{i})=curResult;
    % Do posthoc anovas to find the significant differences
    
    for var=1:6 % Ignore the AIS and Glia group
        [p(var,i),~,stat{var,i}] = ...
            anova1(curRatio(:,var),cortexArea.(seedT{i}),'off');
        MC{var,i} = multcompare(stat{var,i},'display','off');
    end
end
%% test values which are significant from the multiple anovas
sigAnova=(p<0.05/6);
significance=array2table(sigAnova,'RowNames',aggRatios{1}.Properties.VariableNames(2:7),...
    'VariableNames',{'L2','Deep'});
disp(significance)