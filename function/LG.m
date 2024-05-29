function [sort_locs,sort_descs,LG_clusters] = LG(locs,descs,step5,beta)
    n_locs = size(locs,1);
    [sort_descs,idx] = sortrows(descs);
    sort_locs = locs(idx,:);
    if n_locs > 10*step5
        if n_locs<beta*step5
            LG_clusters = {(1:n_locs)'};
        else
            v = 1:ceil(n_locs/step5);
            v = v';
            high = min(n_locs,v*step5);
            low = ones(size(high));
            low(2:end) = high(1:end-1)-round((beta-1)*step5);
            cls = [low,high];
            n_cls = size(cls,1);
            LG_clusters = cell(1,n_cls);
            for i = 1:n_cls
                idx = cls(i,1):cls(i,2);
                LG_clusters{i} = idx';
            end
        end
    else
        LG_clusters = {(1:n_locs)'};
    end
end