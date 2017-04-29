clear all;
clc;
close all;
addpath('Funcs');
doFrameRemoving = false;
useSP = true;           %You can set useSP = false to use regular grid for speed consideration
source = 'Data/source/Saliency';       %of input images
% SP = 'Data/superpixel';         %for saving superpixel index image and mean color image
dest = 'Data/dest2';       %saliency maps
srcSuffix = '.jpg';
if ~exist(dest, 'dir')
    mkdir(dest);
end
files = dir(fullfile(source, strcat('*', srcSuffix)));
for k=1:length(files)
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));
    %% Pre-Processing: Remove Image Frames
    %% Source: Github - thenkao
    srcImg = imread(fullfile(source, srcName));
%     srcImg = imresize(srcImg,0.2);
%     [t1,t2] = superpixels(srcImg,500);
%     outputImage = zeros(size(srcImg),'like',srcImg);
%     idx = label2idx(t1);
%     numRows = size(srcImg,1);
%     numCols = size(srcImg,2);
%     for labelVal = 1:t2
%         redIdx = idx{labelVal};
%         greenIdx = idx{labelVal}+numRows*numCols;
%         blueIdx = idx{labelVal}+2*numRows*numCols;
%         outputImage(redIdx) = mean(srcImg(redIdx));
%         outputImage(greenIdx) = mean(srcImg(greenIdx));
%         outputImage(blueIdx) = mean(srcImg(blueIdx));
%     end
    if doFrameRemoving
        [noFrameImg, frameRecord] = removeframe(srcImg, 'sobel');
        [h, w, chn] = size(noFrameImg);
    else
        noFrameImg = srcImg;
        [h, w, chn] = size(noFrameImg);
        frameRecord = [h, w, 1, h, 1, w];
    end
    
    %% SUPERPIXELATE
    pixNumInSP = 600;                           %pixels in each superpixel
    spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image
    
    % SLIC is the old method, geodesic grid is the new vala
    if useSP
        [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, spnumber);
    else
        [idxImg, adjcMatrix, pixelList] = Grid_Split(noFrameImg, spnumber);        
    end
    %% Get super-pixel properties
    spNum = size(adjcMatrix, 1);
    meanRgbCol = GetMeanColor(noFrameImg, pixelList); %mean over 3 channels
    meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255); %CIELabspace
    meanPos = GetNormedMeanPos(pixelList, h, w); % Mean centre pos of spxls
    bdIds = GetBndPatchIds(idxImg); % superpxls on the boundary
    colDistM = GetDistanceMatrix(meanLabCol); 
    posDistM = GetDistanceMatrix(meanPos);
    % Source Github thenkao
    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
    
    %% Saliency Uniqueness - objectivity
    [bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
    %% Geodesic Saliency with Manifold Ranking
    [stage2, stage1, bsalt, bsalb, bsall, bsalr] = ManifoldRanking(adjcMatrix, idxImg, bdIds, colDistM);
    
    smapName=fullfile(dest, strcat(noSuffixName, '_salient.jpg'));
    SaveSaliencyMap(stage2, pixelList, frameRecord, smapName, true);
%     imwrite(outputImage,strcat(k,'_abs.png'));
    
end