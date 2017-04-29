if ~exist('Data/blended', 'dir')
    mkdir('Data/blended');
end
levels = 3;
for jjj=1:12
    src = double(imread(strcat('Data/source/Saliency/',num2str(jjj),'.jpg')));
    [a, b, c] = size(src);
    tgt = imresize(double(imread('Data/source/grass.jpg')), [a,b]);
    masks = mask(strcat(num2str(jjj)));
%     figure, imshow(masks, []);
    src_lp = LaplacianPyramid(src,levels);
    tgt_lp = LaplacianPyramid(tgt,levels);
    MSK = repmat(masks,[1, 1, 3]);
    mask_gp = GaussianPyramid(MSK,levels);

    mask_cgp = GaussianPyramid(imcomplement(MSK),levels);
    resultant = {};
    for i = 1:levels
        tmp1 = [mask_gp{i}];
        tmp2 = [mask_cgp{i}];
        resultant{i} = src_lp{i}.*tmp1 + tgt_lp{i}.*tmp2;
    end
    fin = reconstruct(resultant);
    path = strcat('Data/blended/',num2str(jjj),'_sal.jpg');
    imwrite(uint8(fin), path)
end