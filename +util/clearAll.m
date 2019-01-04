function [] = clearAll()
% CLEARWORKSPACEFIGURES Clear all variables in the workspace and close all
% figure windows. Usually run before making a new figure to prevent
% unncessary interactions

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

evalin('base','clearvars');
evalin('base','close all');
util.setColors;
end

