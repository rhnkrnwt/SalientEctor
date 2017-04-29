function fina = reconstruct(lp)
    sz = size(lp{1});
    l = size(lp,2);
    final = zeros(sz);
    for i = 1:l
       y = imresize(lp{i},sz(1:2),'nearest');
       final = final + y;
    end
    fina = final(11:sz(1)-8,8:sz(2)-8,:);
end