% Read synapse information
[synCount,~,~] = axon.extractInfoInhibitoryAxons;
% Write the synapse counts to csv files
pathR = '/home/alik/code/alik/R';
layer2Matrix = synCount{1,5}{:,2:end};
deepMatrix = synCount{2,5}{:,2:end};
csvwrite(fullfile(pathR,'layer2.csv'),layer2Matrix);
csvwrite(fullfile(pathR,'deep.csv'),deepMatrix);