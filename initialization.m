
addpath('data');
addpath('vlfeat');

addpath('compare');
addpath('compare/Common');
addpath('compare/RANSAC');

addpath('GraCostMatchMex');


addpath('./compare/DTSGM_release_v1.1');
addpath('./compare/DTSGM_release_v1.1/utils/');
%% Algorithms
% You should edit "setPath.m" and "setMethods.m" to add another algorithm
addpath('./compare/DTSGM_release_v1.1/Methods/RRWM/'); % Reweighted Random Walks Matching by Cho et al. ECCV2010
addpath('./compare/DTSGM_release_v1.1/Methods/SM/'); % Spectral Matching by Leordeanu and Hebert. ICCV2005
addpath('./compare/DTSGM_release_v1.1/Methods/TBMA/'); % Spectral Matching by Leordeanu and Hebert. ICCV2005
addpath('./compare/DTSGM_release_v1.1/Methods/TBMAyumin/');
addpath('./compare/DTSGM_release_v1.1/Methods/TBMA3/');
addpath('./compare/DTSGM_release_v1.1/Methods/TBMA3test/');
addpath('./compare/DTSGM_release_v1.1/Methods/TBMA3test2/');
addpath('./compare/DTSGM_release_v1.1/Methods/IPFP/'); 
addpath('./compare/DTSGM_release_v1.1/Methods/GAGM/'); 
addpath('./compare/DTSGM_release_v1.1/Methods/HGM/');
addpath('./compare/DTSGM_release_v1.1/Methods/SEA/'); 
addpath('./compare/DTSGM_release_v1.1/Methods/TBMA_reproduce_yumin/'); 

addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/'); 
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/lib/option');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/lib/pr');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/lib/matrix');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/lib/cell');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/matrix');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/gm');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/knl');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/hun');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/lib/basic');
addpath('./compare/DTSGM_release_v1.1/Methods/FGM_jungmin/lib/gph');


old = cd;
cd ./vlfeat/toolbox
vl_setup;
cd(old);
