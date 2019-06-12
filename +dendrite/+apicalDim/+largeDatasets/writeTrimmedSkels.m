% Write the trimmed skeletons which could be used for measurement of apical
% dendrite diameter
util.clearAll;
apTuft=apicalTuft.getObjects('l2vsl3vsl5');

for i=1:2
    apTuftTrimmed{i}=apTuft{i}.getBackBone;
end

Dir='/home/alik/code/apicaltuftpaper/annotationData/apicalDiameter/largeDatasets/';
for i=1:2
    apTuftTrimmed{i}.write([],Dir);
end