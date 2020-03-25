%% Fig. 4BC: Cortical region comparison for axonal specificity

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputDir = fullfile(util.dir.getFig(4),'BC');
util.mkdir(outputDir)
c = util.plot.getColors();

%% Get fraction of synapses made by these axons into the 8 postsynaptic target groups
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio = synRatio.Variables;

%% B: Innervation probability for axons seeded from layer 2 apical dendrites
fh = figure;ax = gca;
x_width = 5.68501;
y_width = 3.08505;
% Plot
hold on
util.plot.errorbarSpecificity(synRatio(1,1:4),[],...
    c.colorsCortex);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'B_L2seeded.svg');

%% C: Innervation probability for axons seeded from DL apical dendrites
fh = figure;ax = gca;
% Plot
hold on
util.plot.errorbarSpecificity(synRatio(2,1:4),[],...
    c.colorsCortex);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'C_DeepSeeded.svg');

% Note: raw data is included in excel sheet for Fig. 3BD