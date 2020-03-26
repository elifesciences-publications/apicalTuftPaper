%% Fig. 4: MANOVA test for cortical region comparison
% First, a MANOVA test is applied to the specificity of axons seeded from
% L2 and Deep apical dendrites. This test finds if any mean is different
% from any other. The output represents dime
% Next, we apply the bonferroni corrected onw-way anova to each specificity
% to find the significant differences (Only soma in the L2 group)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio = synRatio.Variables;

%% MANOVA test for the cortical area cortical areas
nrAxons = cellfun(@height,synRatio(:,1:4));
aggRatios = synRatio(:,5);
seedT = {'L2seeded','Deepseeded'};
stat = cell(6,2);
p_anova1 = zeros(6,2);
for seedType = 1:2
    % Note:
    % The L2 groups within-group sum of squares and cross products matrix
    % is singular. Therefore, we removed the AIS and Glia groups (mostly
    % zeros)
    curRatio = aggRatios{seedType}{:,2:7};
    gIDs = repelem([1,2,3,4],nrAxons(seedType,:));
    gNames = {'S1','V2','PPC','ACC'}';
    curGroups = gNames(gIDs);
    % Manova test: The d represents the dimensionality of the means, if d=0
    % then one cannot reject the hypothesis that all means are the same
    [curResult.d,curResult.p,curResult.stat] = ...
        manova1(curRatio,curGroups);
    % Display p-values
    disp(['The MANOVA test result for ',seedT{seedType},...
        ' : p-values: ',num2str(curResult.p'), ...
        ', dimensions: ',num2str(curResult.d')])
    manovaTbl.(seedT{seedType}) = curResult;
    
    % Do posthoc on-way anovas where there is significant difference in
    % MANOVA
    for targetType = 1:6 % Ignore the AIS and Glia group
        [p_anova1(targetType,seedType),~,~] = ...
            anova1(curRatio(:,targetType), curGroups, 'off');
    end
end

%% Use the p-values of one-way anovas to find significant test results
alpha = 0.05;
sigAnova = (p_anova1 < alpha/6);
significance = array2table(sigAnova,'RowNames',...
    aggRatios{1}.Properties.VariableNames(2:7),...
    'VariableNames',{'L2seeded','Deepseeded'});
disp('Significance test results (one-way anova, Bonferroni correction): ')
disp(significance)

%% Materials and Methods, under "Statistics"
% Total fraction of synapses that make up the Glia and the AIS target
% groups
synCount = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');
totalSynNumbers = sum(synCount.Aggregate{1}{:,2:9},'all')+...
    sum(synCount.Aggregate{2}{:,2:9},'all');
AIS_Glia = sum(synCount.Aggregate{1}{:,8:9})+...
    sum(synCount.Aggregate{2}{:,8:9});

fraction = round(AIS_Glia./totalSynNumbers,4); 
disp(['Fraction of synapses made to AIS and Glia respectively: ',...
    num2str(fraction.*100)]);