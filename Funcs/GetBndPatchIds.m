function bdIds = GetBndPatchIds(idxImg, thickness)
if nargin < 2
    thickness = 8;
end
bdIds=unique([
    unique( idxImg(1:thickness,:) );
    unique( idxImg(end-thickness+1:end,:) );
    unique( idxImg(:,1:thickness) );
    unique( idxImg(:,end-thickness+1:end) )
    ]);
