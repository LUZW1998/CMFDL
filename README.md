# Image Copy-Move Forgery Detection and Localization Scheme: How to Avoid Missed Detection and False Alarm

## Introduction
Image copy-move is an operation that replaces one part of the image with another part of the same image, which can be used for illegal purposes due to the potential semantic changes. Recent studies have shown that keypoint-based algorithms achieved excellent and robust localization performance even when small or smooth tampered areas were involved. However, when the input image is low-resolution, most existing keypoint-based algorithms are difficult to generate sufficient keypoints, resulting in more missed detections. In addition, existing algorithms are usually unable to distinguish between Similar but Genuine Objects (SGO) images and tampered images, resulting in more false alarms. This is mainly due to the lack of further verification of local homography matrix in forgery localization stage. To tackle these problems, this paper firstly proposes an excessive keypoint extraction strategy to overcome missed detection. Subsequently, a group matching algorithm is used to speed up the matching of excessive keypoints. Finally, a new iterative forgery localization algorithm is introduced to quickly form pixel-level localization results while ensuring a lower false alarm. Extensive experimental results show that our scheme has superior performance than state-of-the-art algorithms in overcoming missed detection and false alarm.

## Information of the Author
This code was developed by Zhaowei Lu. <br />
luzhaoweizzu@163.com <br />
Part of the code has been improved by Li et al [1].

## Contribution
The main contribution of our code: <br />
function\CM_feature -> detect keypoints and extract features (based on VL_FEAT) <br />
function\CM_match -> feature matching (improved by Li et al) <br />
function\CM_localization -> forgery localization (new iterative forgery localization) <br />
function\entropy_cluster -> entropy cluster <br />
function\LG -> Lexicographic Grouping <br />
OtMFD -> Twenty tampered images with one-to-many copy-move <br />


The Performance on Some Public Datasets (Windows 11, Matlab 2018a):
Datasets                TPR         FPR         F-i         F-p
GRIP:                   100         0           100         95.57
CMH+GRIPori [1]:        100         0           100         94.39
CoMoFoD-BASE:           94.5		    6.5         94.03		    86.44
FAU:                    100         2.08		    98.97		    88.96
MICC-600:               96.25		    0.68		    97.16		    90.39
SSRGFD-CMFD:            76.68		    0.54		    86.40		    67.77

## Configuration
To run this code, you must configure VL_FEAT in matlab (We test the code under VL_FEAT 0.9.21).

# Reference
[1] Li Y, Zhou J. Fast and effective image copy-move forgery detection via hierarchical feature point matching[J]. IEEE Transactions on Information Forensics and Security, 2018, 14(5): 1307-1322.
