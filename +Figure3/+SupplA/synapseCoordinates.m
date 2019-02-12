function Coords=synapseCoordinates(skel, tr, stringSynapse)
% Author: Jan Odenthal <jan.odenthal@brain.mpg.de>
%Get Synapse ccordinates
% Author: Jan Odenthal <jan.odenthal@brain.mpg.de>
allSynapses=[];
for dd=1:length(stringSynapse)
    allSynapses = [allSynapses;...
        skel.getNodesWithComment(stringSynapse{dd},tr,'partial')];
end
trNodes = bsxfun(@times,skel.nodes{tr}(:,1:3),skel.scale);
Coords=trNodes(allSynapses, 1:3);
end
