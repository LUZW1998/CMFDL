function [inliers] = check_orientation(cos_t, sin_t, o1, o2, t)
    theta = acos(cos_t);
    if cos_t<=0 && sin_t<=0 || cos_t>0 && sin_t<0
       theta = 2*pi - theta;
    end
    est_o = theta/pi*180;

    p1_o =o1./pi.*180;
    p2_o = o2./pi.*180;
    p1_o(p1_o<0) = p1_o(p1_o<0) + 360;
    p2_o(p2_o<0) = p2_o(p2_o<0) + 360;

    dif_o = p2_o-p1_o;
    dif_o(dif_o<0) = dif_o(dif_o<0) + 360;
    dif_o2 = 360-dif_o;
    inliers1= abs(dif_o - est_o)<t;
    inliers2= abs(dif_o2 - est_o)<t;
    inliers = find(inliers1 | inliers2);
end