function distM = GetDistanceMatrix(feature)
spNum = size(feature, 1);
DistM2 = zeros(spNum, spNum);
for n = 1:size(feature, 2)
    DistM2 = DistM2 + ( repmat(feature(:,n), [1, spNum]) - repmat(feature(:,n)', [spNum, 1]) ).^2;
end
distM = sqrt(DistM2);
