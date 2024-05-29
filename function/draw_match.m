% This function is used for draw match pairs.
% Input: We assume there are N inputs.
% p1,p2 --> match pairs. Array -> N*4 [horizonal, vertical, scale,
% orientation]
function draw_match(img_rgb,p1,p2)
    figure;
    imshow(uint8(img_rgb),[],'border','tight')
    [h,w,~] = size(img_rgb);
    line_width = max(1, int8(h/1024 * w/768));
    line_width = min(line_width, 1);
    hold on
    if size(p1,2)~=0
        for i = 1: size(p1,2)
            line([p1(1,i) p2(1,i)], [p1(2,i) p2(2,i)], 'color', 'r','LineWidth', line_width);
%             pause(0.01)
        end
        scatter(p1(1,:),p1(2,:),'g.');
        scatter(p2(1,:),p2(2,:),'b.');
    end
    pause(0)
end
