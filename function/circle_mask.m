function patch_mask = circle_mask(radius)
    [X,Y]  = meshgrid(-radius:radius);
    patch_mask = X.^2+Y.^2 <= radius^2;
end