function [sample] = datasample(data,numberOfsamples)
% DATASAMPLE Sample data with replacement

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if length(data)>numberOfsamples
    sample=datasample(data,numberOfsamples,'Replace',false);
else
    sample=data;
    if length(data)<numberOfsamples
    disp('datasample: sample size larger than input data');
    end
end

end

