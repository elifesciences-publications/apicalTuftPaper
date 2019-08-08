function [thisTable] = fixShaftSeededL2Table(thisTable)
%FIXSHAFTSEEDEDL2TABLE Convert the large shaft seeded axons from the L2
%datasets into a Shaft/Spine table
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

assert(all(sum(thisTable{:,2:end},2)-1<1e-8));
vars2Del=thisTable.Properties.VariableNames([2,3,5:end]);
thisTable.Spine=thisTable.SpineSinglePlusApicalSingle;
thisTable.Shaft=1-thisTable.SpineSinglePlusApicalSingle;
thisTable=removevars(thisTable,vars2Del);
end

