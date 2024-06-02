function map = CM_locailzation(img,para)
    M1 = para.M1;
    M2 = para.M2;
    [h,w] = size(img);
    n_min_match = para.n_min_match;
    n_MSS = para.n_MSS;
    t3 = para.t3;
    min_num_inlier = para.min_num_inlier;
    match_ratio = para.match_ratio;
    radius = para.radius;
    r_operation = para.r_operation;
    min_size = para.min_size;
    max_hole_size = para.max_hole_size;
    im = double(img);
    
    map1 = zeros(h,w);
    map2 = zeros(h,w);
    n_post = size(M1,2);

    % for original J-linkage, n_MSS=12
    if n_post < n_min_match
        map = imresize(zeros(h,w),1/para.s);
        fprintf('Original image!\n');
        return;
    end

    max_iteration = min([round(n_post/25),15]);
    visited = zeros(n_post,1);

    % New iteration forgery localization
    for iteration = 1:max_iteration
        unvisited = find(visited == 0);
        n_unvisited = length(unvisited);
        if n_unvisited < n_MSS
            break;
        end
        p1 = M1(:,unvisited);
        p2 = M2(:,unvisited);


        % choose maximum density sample set
        mask = double(circle_mask(para.t2));
        location_match1 = zeros(h,w);
        location_match2 = zeros(h,w);
        for i = 1:n_unvisited
            y1 = p1(1,i);
            x1 = p1(2,i);
            y2 = p2(1,i);
            x2 = p2(2,i);
            location_match1(x1,y1) = location_match1(x1,y1)+1;
            location_match2(x2,y2) = location_match2(x2,y2)+1;
        end
        density_match1 = imfilter(location_match1,mask);
        density_match2 = imfilter(location_match2,mask);
        p1_indx = (p1(1,:)-1)*h+p1(2,:);
        p2_indx = (p2(1,:)-1)*h+p2(2,:);
        density = max([density_match1(p1_indx);density_match2(p2_indx)]);
        [~,sample_idx] = max(density);
        visited(sample_idx) = 1;
        dist1 = (p1(1,:)-p1(1,sample_idx)).^2+(p1(2,:)-p1(2,sample_idx)).^2;
        dist2 = (p2(1,:)-p2(1,sample_idx)).^2+(p2(2,:)-p2(2,sample_idx)).^2;
        sample_idx1 = dist1<=t3*t3;
        sample_idx2 = dist2<=t3*t3;
        sample_idx = find(sample_idx1|sample_idx2);
        cur_p1 = p1(:,sample_idx);
        cur_p2 = p2(:,sample_idx);
        n_sample = size(cur_p1,2);
        % check maximum density sample set
        if n_sample < n_MSS || n_sample < n_post*t3*t3/h/w
            visited(unvisited(sample_idx)) = 1;
            continue;
        end

        % do RANSAC    
        t = 0.05;
        [H, inliers_cur] = ransacfithomography2(cur_p1(1:3,:), cur_p2(1:3,:), t);
        cur_x1 = cur_p1(:,inliers_cur);
        cur_x2 = cur_p2(:,inliers_cur);
        % check RANSAC
        if isempty(H) || length(inliers_cur)< 4
            visited(unvisited(sample_idx)) = 1;
            continue;
        end
        visited(unvisited(sample_idx(inliers_cur))) = 1;


        % check orientation
        [U,~,V] = svd(H(1:2,1:2));
        rotation_matrix = U*V';
        indx_o  = check_orientation(rotation_matrix(1), rotation_matrix(2),...
            cur_x1(5,:), cur_x2(5,:), 15);
        if length(indx_o)<size(cur_x2,2)*0.8
            fprintf('check dominant orientation fail, give up!\n');
            continue;
        end

        % Find all inliers in match set P -> (p1,p2)
        x1 = M1(1:3,:);
        x2 = M2(1:3,:);
        Hx1 = round(H*x1);
        invHx2 = round(H\x2);
        D2 = sum((x1-invHx2).^2)+sum((x2-Hx1).^2);
        inliers = find(D2<=8);
        cur_process_p1 = M1(:,inliers);
        cur_process_p2 = M2(:,inliers);

        % Check inliers orientation
        indx_o  = check_orientation(rotation_matrix(1), rotation_matrix(2),...
            cur_process_p1(5,:), cur_process_p2(5,:), 20);
        cur_process_p1 = cur_process_p1(:, indx_o);
        cur_process_p2 = cur_process_p2(:,indx_o);
        visited(inliers(indx_o)) = 1;
        n_process = size(cur_process_p1,2);

        % Check the number of inliers
        if n_process < min_num_inlier
            fprintf('check random matches, continue!\n');
            continue;
        elseif n_process<match_ratio*n_post && n_post>5000
                continue;
        else
            fprintf('detect forgery patch!\n');
        end


        % Set localization parameter
        n_process = size(cur_process_p1,2);
        diff_matrix = zeros(n_process,1);
        % Forgery localization using robust grayscale statistical information 
        for i = 1:n_process
            x1 = cur_process_p1(2,i);
            y1 = cur_process_p1(1,i);
            x2 = cur_process_p2(2,i);
            y2 = cur_process_p2(1,i);
            diff_matrix(i) = im(x1,y1)-im(x2,y2);
        end
        Q1 = prctile(diff_matrix,25);
        Q3 = prctile(diff_matrix,75);
        IQR = Q3-Q1;
        idx = diff_matrix>=Q1-1.5*IQR & diff_matrix<=Q3+1.5*IQR;
        diff_matrix = diff_matrix(idx);
        diff_low = min(diff_matrix);
        diff_low = max(diff_low,-16);
        diff_high = max(diff_matrix);
        diff_high = min(diff_high,16);

        % Localization suspect region1
        R1 = round(radius*cur_process_p1(4,:));
        R1(R1>2*radius) = 2*radius;
        position1 = [cur_process_p1(1:2,:);R1]';
        cur_map1 = zeros(h,w);
        cur_suspect_map1 = insertShape(cur_map1, 'FilledCircle',position1);
        cur_suspect_map1 = imbinarize(cur_suspect_map1(:,:,1));
        [x1,y1] = find(cur_suspect_map1 == 1);
        X1 = [y1,x1,ones(length(x1),1)]';
        X2_ = round(H*X1);
        idx = X2_(1,:)<w & X2_(2,:)<h & X2_(1,:)>0 & X2_(2,:)>0;
        X1 = X1(:,idx);
        X2_ = X2_(:,idx);
        for i = 1:size(X1,2)
            x1 = X1(2,i);
            y1 = X1(1,i);
            x2 = X2_(2,i);
            y2 = X2_(1,i);
            if im(x1,y1)-im(x2,y2)>=diff_low &&...
                    im(x1,y1)-im(x2,y2)<=diff_high
                cur_map1(x1,y1) = 1;
                cur_map1(x2,y2) = 1;
            end
        end
        map1 = bitor(cur_map1,map1);

        % Localization suspicious region2
        R2 = round(radius*cur_process_p2(4,:));
        R2(R2>2*radius) = 2*radius;
        position2 = [cur_process_p2(1:2,:);R2]';
        cur_map2 = zeros(h,w);
        cur_suspect_map2 = insertShape(cur_map2, 'FilledCircle',position2);
        cur_suspect_map2 = imbinarize(cur_suspect_map2(:,:,1));
        [x2,y2] = find(cur_suspect_map2 == 1);
        X2 = [y2,x2,ones(length(x2),1)]';
        X1_ = round(H\X2);
        idx = X1_(1,:)<w & X1_(2,:)<h & X1_(1,:)>0 & X1_(2,:)>0;
        X2 = X2(:,idx);
        X1_ = X1_(:,idx);
        for i = 1:size(X2,2)
            x2 = X2(2,i);
            y2 = X2(1,i);
            x1 = X1_(2,i);
            y1 = X1_(1,i);
            if im(x1,y1)-im(x2,y2)>=diff_low &&...
                    im(x1,y1)-im(x2,y2)<=diff_high
                cur_map2(x1,y1) = 1;
                cur_map2(x2,y2) = 1;
            end
        end
        map2 = bitor(cur_map2,map2);
    end
    map = bitor(map1,map2);
    map = imclose(map,strel('disk',r_operation));
    map = imopen(map,strel('disk',r_operation));
    map = fill_small_holes(map, max_hole_size);
    map = bwareaopen(map,min_size);
    map = imresize(map,1/para.s);
    if sum(map(:))>0
        fprintf('Forgery image!\n');
    else
        fprintf('Original image!\n');
    end
end

