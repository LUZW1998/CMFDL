clear;
clc;
close all
addpath(genpath('function'));
dbstop if error

image_path = 'images\_r30_s1200statue.png';

img_rgb = imread(image_path);
[h,w,~] = size(img_rgb);
if (h+w)/2 > 1024
    para.s = 2;
else
    para.s = 4;
end
img_rgb = imresize(img_rgb,para.s);
[h,w,~] = size(img_rgb);
img = rgb2gray(img_rgb);
E = entropyfilt(img);

% Show matching
show_match = 1;
% Detection parameters
para.E = E;
para.step1 = 40;
para.step2 = 10;
para.step3 = 1;
para.step4 = 0;
para.step5 = 500;
para.beta = 1.1;
para.thre = 0.5;
para.t1 = max([16*para.s,min(h,w)/40,50]);
para.t2 = max([50,para.t1/2]);
para.eliminate = 1;

% post-processing parameters
if max(h,w)<1024
    para.n_min_match = 4;
    para.n_MSS = 4;
    para.t3 = max([min(h,w)/15,50]);
    para.min_num_inlier = 15;
    % We forgot this setting, but it must be one of 16 or 32
    para.radius = 32;
    para.match_ratio = 0.1;
    para.r_operation = 5;
    para.max_hole_size = round(h*w/1000);
    para.min_size = round(h*w/1000);
elseif max(h,w)<2048
    para.n_min_match = 12;
    para.n_MSS = 6;
    para.t3 = max([min(h,w)/15,50]);
    para.min_num_inlier = 25;
    para.radius = 32;
    para.match_ratio = 0.1;
    para.r_operation = 10;
    para.max_hole_size = round(h*w/1000);
    para.min_size = round(h*w/1000);
else
    para.n_min_match = 25;
    para.n_MSS = 6;
    para.t3 = max([min(h,w)/15,50]);
    para.min_num_inlier = 25;
    para.radius = 32;
    para.match_ratio = 0.1;
    para.r_operation = 10;
    para.max_hole_size = round(h*w/1000);
    para.min_size = round(h*w/1000);
end

[locs,descs] = CM_feature(img);
para.locs = locs;
para.descs = descs;
[M1,M2] = CM_match(img,para);

if show_match
    draw_match(img_rgb,M1,M2)
end
para.M1 = M1;
para.M2 = M2;

map = CM_locailzation(img,para);

figure;
imshow(map,'border','tight')
