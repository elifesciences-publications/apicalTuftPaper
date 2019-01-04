function [ bootstrapSample ] = bootStrapSamplePolya( polyaAlpha,sampleMatrix )
% bootStrapSamplePolya returns a sample from the polya distribution
% matching the shape of the sample Matrix. 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

bootstrapSample=zeros(size(sampleMatrix));
for curSampleId=1:size(sampleMatrix,1)
    axonSynNumber=sum(sampleMatrix(curSampleId,:));
    bootstrapSample(curSampleId,:)=polya_sample(polyaAlpha,axonSynNumber);
end
end

