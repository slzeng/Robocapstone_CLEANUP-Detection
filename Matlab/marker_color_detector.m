





% function weed_color_detector(I)

% % % for LED Brightness= 50
% g_lower = 120;
% g_upper = 200;
% r_lower = 150;
% r_upper = 100;
% b_upper = 200;

% for LED Brightness= 50 with fake leaf
g_lower = 120;
g_upper = 200;
r_lower = 120;
r_upper = 100;
b_upper = 110;


% b_lower = 50;

img = imresize(I,.5);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
img = (G>R).*(G>B) .* (G>g_lower) .* (B<b_upper);
% figure(4)
% imshow(img)

% pause()
se5 = strel('disk',2);
img = imerode(img,se5);
% imshow(img)
% pause()
% img = imgaussfilt(img,.5);

se = strel('disk',6);
img = imdilate(img,se);
% imshow(img)
% pause()
img = imerode(img,se5);
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