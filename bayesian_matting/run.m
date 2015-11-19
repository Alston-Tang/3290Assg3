%%
% In this part you are required to implement bayesian matting by yourself.
% img is stored in the folder ./img
% segmentation map is stored in the folder ./segmentation
% where 0: background , 128:unknow , 255: foreground
img          = imread('./img/3.png');
segmentation = imread('./segmentation/3.png');

[F B alpha] = bayesian_matting(img, segmentation);
