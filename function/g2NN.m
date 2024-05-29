% The g2NN feature matching was completed in this function.
% Attention: kp1, kp2 represent SIFT key-points. des1, des2 correspond to
% the feature of kp1 and kp2 respectively. We assume there are M
% key-point inputs.
% Input:
% kp1, kp2 --> SIFT key-points and features. Array -> M*4 [horizontal,
% vertical, scale, orientation]
% des1, des2 --> SIFT key-points and features. Array -> M*128
% threshold --> the ratio of the closest distance to the second closest
% distance
% Output: return match pairs. Here, p1 is the point on the left in the
% pair.We assume there are N key-point outputs.
% p1,p2 --> SIFT key-points. Array -> N*4 [horizontal, vertical, scale,
% orientation]
function [p1,p2]=g2NN(kp1,des1,kp2, des2,threshold)
    p1=[];
    p2=[];
    if size(kp1,1)<1
        return;
    end
    dot_product=des1*des2';
    for i = 1:size(des1,1)
        [values,indexes]=sort(acos(dot_product(i,:)));
        j=2;
        while j+1<size(values,2)&&values(j)<values(j+1)*threshold
            if kp1(i,1)<kp2(indexes(j),1)
                p1=[p1;kp1(i,:)];
                p2=[p2;kp2(indexes(j),:)];
                j=j+1;
            else
                p1=[p1;kp2(indexes(j),:)];
                p2=[p2;kp1(i,:)];
                j=j+1;
            end
        end
    end
end
