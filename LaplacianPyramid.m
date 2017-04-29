function [lp] = LaplacianPyramid(im,l)
    arr = GaussianPyramid(im,l);
    lp{l} = arr{l};
    for i = 1:l-1
        %lp{l-i}
        target = size(arr{l-i});
        x = imresize(arr{l-i+1},target(1:2),'nearest');
        lp{l-i} = double(arr{l-i}) -double(x);
    end
    
end

