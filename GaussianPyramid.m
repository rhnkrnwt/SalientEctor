function [arr] = GaussianPyramid(im,l)
    filt = fspecial('gaussian',5,2);
    arr ={};
    arr{1} = im;
    for i = 2:l
        imf = imfilter(double(im),filt);
        im = imf(1:2:size(imf,1),1:2:size(imf,2),:);
        arr{i} = im;
    end
end
