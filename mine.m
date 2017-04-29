function [lab] = mine(rgbIm)
% convert to CIELab space
nColors = 7;
% repeat the clustering 3 times to avoid local minima
%[cluster_idx, cluster_center] = kmeans(pseudolab,nColors,'distance','cosine', ...
%'Replicates',3);

%pixel_labels = reshape(cluster_idx,nrows,ncols);
%imshow(pixel_labels, []);
srcImg = rgbIm;
[L,N] = superpixels(srcImg,500);

outputImage = zeros(size(srcImg),'like',srcImg);
idx = label2idx(L);
numRows = size(srcImg,1);
numCols = size(srcImg,2);
for labelVal = 1:N
	redIdx = idx{labelVal};
	greenIdx = idx{labelVal}+numRows*numCols;
	blueIdx = idx{labelVal}+2*numRows*numCols;
	outputImage(redIdx) = mean(srcImg(redIdx));
	outputImage(greenIdx) = mean(srcImg(greenIdx));
	outputImage(blueIdx) = mean(srcImg(blueIdx));
end    

colorTransform = makecform('srgb2lab');
lab = applycform(outputImage, colorTransform);
pseudolab = double(lab(:,:,2:3));
nrows = size(pseudolab,1);
ncols = size(pseudolab,2);
pseudolab = reshape(pseudolab,nrows*ncols,2);


imshow(lab)

