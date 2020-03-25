function [] = ksdensity(data,color,bandwidth,bounds)
%KSDENSITY Plot the ksdensity
if ~exist('bandwidth','var') || isempty(bandwidth)
    bandwidth = [];
end
if ~exist('bounds','var') || isempty(bounds)
    allData = cat(1,data{:});
    bounds = [min(allData(:)),max(allData(:))];
end
if ~iscell(data)
    data ={data};
end
if ~iscell(color)
    color ={color};
end
range = diff(bounds);
hold on
for i = 1:length(data)
    curData = data{i};
    % The data should be contained within the Support range so we have to add
    % 1e-5 to the bounds to make sure they contain the data
    [f,xi] = ksdensity(curData,bounds(1):range/100:bounds(2),'Support',...
        [bounds(1)-1e-5 bounds(2)+1e-5],'BoundaryCorrection','reflection',...
        'Bandwidth',bandwidth);
    plot(xi,f,'-','Color', color{i});
    % Make sure area under the probability density estimate is =1
    if ((1-trapz(xi,f))>1e-3)
        warning (['Kernel Density sums up to: ',num2str(trapz(xi,f))])
    end
end
end

