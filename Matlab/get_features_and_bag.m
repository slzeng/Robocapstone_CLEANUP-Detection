%% Load image data
imset = imageSet('data/WeedData','recursive');

%% Pre-process Training Data: *Feature Extraction*
% Requires: Computer Vision System Toolbox

% Create a bag-of-features from the Weed image database
bag = bagOfFeatures(imset,'VocabularySize',500,...
    'PointSelection','Detector','UseParallel',1);

% Encode the images as new features
imagefeatures = encode(bag,imset);

%% Create a Table using the encoded features
WeedData         = array2table(imagefeatures);
WeedData.WeedType = getImageLabels(imset);