# Image Copy-Move Forgery Detection and Localization Scheme: How to Avoid Missed Detection and False Alarm
We provide the code design for each stage of the paper. For parameters, it is included in CMFDL.p. After receiving the paper, we will provide the.m file for this part.

## Introduction
<p>Image copy-move is an operation that replaces one part of the image with another part of the same image, which can be used for illegal purposes due to the potential semantic changes. Recent studies have shown that keypoint-based algorithms achieved excellent and robust localization performance even when small or smooth tampered areas were involved. However, when the input image is low-resolution, most existing keypoint-based algorithms are difficult to generate sufficient keypoints, resulting in more missed detections. In addition, existing algorithms are usually unable to distinguish between Similar but Genuine Objects (SGO) images and tampered images, resulting in more false alarms. This is mainly due to the lack of further verification of local homography matrix in forgery localization stage. To tackle these problems, this paper firstly proposes an excessive keypoint extraction strategy to overcome missed detection. Subsequently, a group matching algorithm is used to speed up the matching of excessive keypoints. Finally, a new iterative forgery localization algorithm is introduced to quickly form pixel-level localization results while ensuring a lower false alarm. Extensive experimental results show that our scheme has superior performance than state-of-the-art algorithms in overcoming missed detection and false alarm.</p>

## Author Information
This code was developed by Zhaowei Lu (upload date: 13/6/2024). <br />
luzhaoweizzu@163.com <br />
Part of the code has been improved by Li et al. [1].

## Contribution
The main contribution of our code: <br />
function\CM_feature -> detect keypoints and extract features (based on VL_FEAT) <br />
function\CM_match -> feature matching (improved by Li et al.) <br />
function\CM_localization -> forgery localization (new iterative forgery localization) <br />
function\entropy_cluster -> entropy cluster <br />
function\LG -> Lexicographic Grouping <br />
OtMFD -> Twenty tampered images with one-to-many copy-move <br />

## Configuration
To run this code, you must configure VL_FEAT in matlab (We tested the code under matlab 2018a, VL_FEAT 0.9.21).

## Reference
If you use this code, please cite the following paper: <br />
[1] Li Y, Zhou J. Fast and effective image copy-move forgery detection via hierarchical feature point matching[J]. IEEE Transactions on Information Forensics and Security, 2018, 14(5): 1307-1322. <br />
[2] This cite will be published after acceptance
