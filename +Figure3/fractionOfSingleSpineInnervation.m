util.clearAll
outputDir=fullfile(util.dir.getFig3,'singleInnervation');
util.mkdir(outputDir);
% Get the apicalSpecificity
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synCount = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');
synapseCount_Agg = cat(1,synCount.Aggregate{:});

fractionDouble = sum(synapseCount_Agg.SpineDouble)/...
    sum([synapseCount_Agg.SpineSingle;synapseCount_Agg.SpineDouble]);