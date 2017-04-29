function im  = mask(file_number)
    disp(file_number);
    prefixpath = 'Data/dest2/';
    suffixpath = '_salient.jpg';
    fname = strcat(prefixpath, file_number, suffixpath);
    im = im2bw(imread(fname));
    se = strel('disk',5);
    im = imdilate(im, se);
end

