This code was developed by Zhaowei Lu.
luzhaoweizzu@163.com
Part of the code has been improved by Li et al. [1].
To run this code, you must configure VL_FEAT in matlab (We tested the code under matlab 2018a, VL_FEAT 0.9.21).


The main contribution of our code:
function\CM_feature -> detect keypoints and extract features(based on VL_FEAT)
function\CM_match -> feature matching(improved by Li et al.)
function\CM_localization -> forgery localization(new iterative forgery localization)
function\entropy_cluster -> entropy cluster
function\LG -> Lexicographic Grouping
OtMFD -> Twenty tampered images with one-to-many copy-move


The Performance on Some Public Datasets (Windows 11, Matlab 2018a):
Datasets                TPR         FPR         F-i         F-p
GRIP:                   100         0           100         95.57
CMH+GRIPori [1]:        100         0           100         94.39
CoMoFoD-BASE:           94.5		6.5         94.03		86.44
FAU:                    100         2.08		98.97		88.96
MICC-600:               96.25		0.68        97.16		90.39
SSRGFD-CMFD:            76.68		0.54        86.40		67.77


[1] Li Y, Zhou J. Fast and effective image copy-move forgery detection via hierarchical feature point matching[J]. IEEE Transactions on Information Forensics and Security, 2018, 14(5): 1307-1322.
