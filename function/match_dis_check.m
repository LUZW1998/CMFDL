% This function is used to check whether the match pairs' distance meet the
% requirements.
% Input: We assume there are M inputs.
% img_rgb --> RGB image.
% match_pair1, match_pair2 --> match pairs. Array -> M*4
% min_pair_dist --> minimum pair distance between match_pair1 and
% match_pair1.
% Output:We assume there are N outputs.
% p1, p2 --> the match pairs that meets the conditions. Array -> N*4
function [p1,p2]=match_dis_check(match_pair1,match_pair2,min_pair_dist)
    p1=[];
    p2=[];
    % check match pair
    if size(match_pair1,1)~=0
        for j=1:size(match_pair1,1)
            % reject too close point pairs
            if norm(match_pair1(j,1:2)-match_pair2(j,1:2))>min_pair_dist
                p1=[p1;match_pair1(j,:)];
                p2=[p2;match_pair2(j,:)];
            end
        end
    end
end
