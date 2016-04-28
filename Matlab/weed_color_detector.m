





% function weed_color_detector(I)

g_lower = 120;
g_upper = 175;
r_lower = 80;
r_upper = 130;
b_upper = 90;
% b_lower = 50;

img = I;
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
% img = (G>g_lower).*(G<g_upper).*(R>r_lower).*(R<r_upper).*(B<b_upper).*(G>R);
% img = (G>R).*(G>B).*(G>g_lower).*(B<b_upper);
img = (G>R).*(G>B).*(G>g_lower).*(B<R);

img = imresize(img,.5);

% figure(4)
% imshow(img)

% pause()
se_erode = strel('disk',7);
img = imerode(img,se_erode);
% imshow(img)
% pause()
% img = imgaussfilt(img,.5);

se = strel('disk',10);
img = imdilate(img,se);

% imshow(img)
% pause()
% se = strel('disk',5);
img = imerode(img,se_erode);
% imshow(img)
% figure(2)

% img = floor(img);
% se = strel('disk',10);
% img = imdilate(img,se);
% imshow(img)
% % pause()
% se = strel('disk',4);
% img = imerode(img,se);
% % imshow(img)
img = imresize(img,2);