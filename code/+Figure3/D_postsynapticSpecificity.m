%% Fig. 3D: 
% postsynaptic innervation fraction map for axons seeded from L2 and DL 
% apical dendrites.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

%% setup
util.clearAll;
outputDir = fullfile(util.dir.getFig(3),'D');
util.mkdir(outputDir)

apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio = synRatio.Variables;

%% Plot Fig. 3d
fh = figure;ax = gca;
x_width = 5.68499;
y_width = 3.08503;
% Plotting
c = util.plot.getColors();
hold on
util.plot.errorbarSpecificity(synRatio(:,5),[],...
    [{c.l2color},{c.dlcolor}]);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'Fig3D.svg');

%% Bootstrap test to compare L2 and DL innervation fraction
TestResults = util.stat.bootStrapTest(synRatio{1,5},synRatio{2,5},false);
writetable(TestResults,fullfile(outputDir,...
    'Fig3D_bootStrapTestResults.txt'));
% Note: excel data is the same as Fig. 3B 
% The data used in this figure matches the data used in Fig. 3B. Here
% we have all the targets and Fig.3B focuses on the AD re-innervation.