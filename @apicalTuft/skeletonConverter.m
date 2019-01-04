function [apTuft] = skeletonConverter(skel,apTuft)
%SKELETONCONVERTER The skel and apTuft should be from the same annotations
% since the properties of apTuft which are not in skel would be retained
% from: https://www.mathworks.com/matlabcentral/answers/92434-how-do-i-cast
% -a-superclass-object-into-a-subclass-object-in-matlab-7-7-r2008b
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

C = metaclass(skel);
P = C.Properties;
for k = 1:length(P)
    if ~P{k}.Dependent
        apTuft.(P{k}.Name) = skel.(P{k}.Name);        
    end    
end


end

