function [down_img] = resize_polar_img(varargin)

%%
% arg 1: target image 
% arg 2: size of the downsized image; the number of [r, theta] for 200m, 360 deg
% arg 3: interpolation type

%%
if nargin == 1
    img = varargin{1};
    rescale_pixel = [40, 60];
    interpolation_method = 'box';
end

if nargin == 2
    img = varargin{1};
    rescale_pixel = varargin{2};
    interpolation_method = 'box';
end

if nargin == 3
    img = varargin{1};
    rescale_pixel = varargin{2};
    interpolation_method = varargin{3};
end

down_img = imresize(img, rescale_pixel, 'method', interpolation_method);

end