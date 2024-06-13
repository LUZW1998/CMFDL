clear;
clc;
close all
addpath(genpath('function'));
dbstop if error

image_path = 'images\001_F.png';

show_match = 0;
% CMFDL: The first parameter represents the image path;
% the second parameter represents whether the match result is displayed
map = CMFDL(image_path,show_match);
figure;
imshow(map,'border','tight')