% normal SIFT
function [locs,descs] = CM_feature(img)
    [h,w] = size(img);
    im = double(img);
    [locs,descs] = vl_sift(single(im),'Octaves',5,'Levels',5);
    locs = locs';
    locs(:,1:2) = round(locs(:,1:2));
    descs = double(descs)';
    idx = locs(:,1)>=1 & locs(:,1)<=w &locs(:,2)>=1 & locs(:,2)<=h;
    locs = locs(idx,:);
    descs = descs(idx,:);
    n_locs = size(locs,1);
    for i = 1:n_locs
        temp = descs(i,:);
        abs_temp = temp*temp';
        descs(i,:) = temp/sqrt(abs_temp);
    end
    n_locs = size(locs,1);
    fprintf('Found %d keypoints.\n', n_locs);
end