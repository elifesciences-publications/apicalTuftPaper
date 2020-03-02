function [] = clearAll()
% CLEARWORKSPACEFIGURES Clear all variables in the base  workspace and close 
% all figure windows. 
% Note: this function is usually called in the begining of a script to
% clear the workspace and close all figure windows

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

evalin('base','clearvars');
evalin('base','close all');
end

