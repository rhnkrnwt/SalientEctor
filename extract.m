if ~exist('Data/extracted', 'dir')
    mkdir('Data/extracted');
end
levels = 3;
for jjj=1:20
    src = double(imread(strcat('Data/source/Cars/num',num2str(jjj),'.jpg')));
    [a, b, c] = size(src);
    tgt = imresize(double(imread('Data/source/Cars/black.jpg')), [a,b]);
    masks = mask(strcat('num',num2str(jjj)));
    bg = 1 - masks;
    MSK = repmat(masks,[1, 1, 3]);
    MSK2 = repmat(bg,[1, 1, 3]);
    fin = MSK.*src + MSK2.*tgt;
    
    path = strcat('Data/extracted/',num2str(jjj),'_sal.jpg');
    imwrite(uint8(fin), path)
end