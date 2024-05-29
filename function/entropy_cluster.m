% locs -> keypoints
% entropy_idx -> keypoints index represent entropy value
function entropy_clusters = entropy_cluster(E,key_indx,step3,step4)
    entropy_pix = E(key_indx);
    v = 1:ceil((7-step4)/step3);
    v = v';
    low = max(0,(v-1)*step3-step4);
    high = min(7,v*step3+step4);
    cls = [low,high];
    entropy_clusters = {};
    for i = 1:size(cls,1)
        low = cls(i,1);
        high = cls(i,2);
        cur_idx = find(entropy_pix>=low & entropy_pix<=high);
        if length(cur_idx) < 10
            continue;
        end
        entropy_clusters = [entropy_clusters,cur_idx];
    end
end