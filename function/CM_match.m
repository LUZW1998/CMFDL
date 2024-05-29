function [M1,M2] = CM_match(img,para)
    %% Invs
    locs = para.locs;
    descs = para.descs;
    E = para.E;
    [h,w] = size(img);
    step1 = para.step1;
    step2 = para.step2;
    step3 = para.step3;
    step4 = para.step4;
    step5 = para.step5;
    beta = para.beta;
    thre = para.thre;
    t1 = para.t1;
    t2 = para.t2;
    eliminate = para.eliminate;
    
    im  =double(img);
    p1 = [];
    p2 = [];
    % gray cluster
    n_locs = size(locs,1);
    if n_locs>5000
        key_indx = (locs(:,1)-1)*h+locs(:,2);
        gray_clusters = gray_cluster(im,key_indx,step1,step2,5);
    else
        gray_clusters = {(1:n_locs)'};
    end

    for i = 1:size(gray_clusters,2)
        idx_gray_cluster = gray_clusters{i};
        locs_gray_cluster = locs(idx_gray_cluster,:);
        descs_gray_cluster = descs(idx_gray_cluster,:);
        % entropy cluster
        n_gray_cluster = size(idx_gray_cluster,1);
        if n_gray_cluster>1000
            key_indx = (locs_gray_cluster(:,1)-1)*h+locs_gray_cluster(:,2);
            entropy_clusters = entropy_cluster(E,key_indx,step3,step4);
        else
            entropy_clusters = {(1:n_gray_cluster)'};
        end

        for j = 1:size(entropy_clusters,2)
            idx_entropy_cluster = entropy_clusters{j};
            locs_entropy_locs = locs_gray_cluster(idx_entropy_cluster,:);
            descs_entropy_descs = descs_gray_cluster(idx_entropy_cluster,:);
            % LG
            [sort_locs,sort_descs,LG_clusters] = LG(locs_entropy_locs,descs_entropy_descs,...
                step5,beta);
            n_LG_clusters = size(LG_clusters,2);

            for k = 1:n_LG_clusters
                idx = LG_clusters{k};
                locs_cur = sort_locs(idx,:);
                descs_cur = sort_descs(idx,:);
                [match1,match2] = g2NN(locs_cur,descs_cur,locs_cur, descs_cur,thre);
                [pair1,pair2]=match_dis_check(match1,match2,t1);
                p1=[p1;pair1];
                p2=[p2;pair2];
            end
        end
    end

    if size(p1,1) == 0
        M1 = [];
        M2 = [];
        fprintf('Found 0 matches.\n');
       return; 
    end

    % Eliminating duplicate matching
    p = round([p1(:,1:2) p2(:,1:2)]);
    [p_temp, indx,~] = unique(p,'rows');
    p1=[p_temp(:,1:2), p1(indx,3:4)];
    p2=[p_temp(:,3:4), p2(indx,3:4)];
    num = size(p1,1);
    M1 = [p1(:,1:2)'; ones(1,num) ; p1(:,3:4)'];
    M2 = [p2(:,1:2)'; ones(1,num) ; p2(:,3:4)'];

    % Removal of isolated matches
    if eliminate
        n_point = size(M1,2);
        mask = double(circle_mask(t2));
        location_match1 = zeros(h,w);
        location_match2 = zeros(h,w);
        for i = 1:n_point
            y1 = M1(1,i);
            x1 = M1(2,i);
            y2 = M2(1,i);
            x2 = M2(2,i);
            location_match1(x1,y1) = location_match1(x1,y1)+1;
            location_match2(x2,y2) = location_match2(x2,y2)+1;
        end
        density_match1 = imfilter(location_match1,mask);
        density_match2 = imfilter(location_match2,mask);
        M1_indx = (M1(1,:)-1)*h+M1(2,:);
        M2_indx = (M2(1,:)-1)*h+M2(2,:);
        density = max([density_match1(M1_indx);density_match2(M2_indx)]);
        idx = find(density>3);
        M1 = M1(:,idx);
        M2 = M2(:,idx);
    end
    n_match = size(M1,2);
    fprintf('Found %d matches.\n', n_match);
end