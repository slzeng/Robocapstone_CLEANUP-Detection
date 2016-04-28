
% figure(1)
% clf
% figure(2)
% clf
% figure(3)
% clf
% figure(4)
% clf
% % count = 0;

% for(count = 50:752)
% 	name = strcat('data/images/frame',sprintf('%4.4d',count),'.jpg')
% 	I = imread(name);

% 	I = I(210:520,380:875,:);
% 	figure(2)
% 	imshow(I)
% 	figure(1)
% 	imshow(I)
% 	hold on
% 	figure(2)
% 	im = single(vl_xyz2lab(vl_rgb2xyz(I)));
% 	segments = vl_slic(im,30,1);
	
% 	[sx,sy]=vl_grad(double(segments), 'type', 'forward') ;
%     s = find(sx | sy) ;
%     imp = I ;
%     imp([s s+numel(im(:,:,1)) s+2*numel(im(:,:,1))]) = 0 ;
%     imshow(imp);
% 	% [featureVector, hogVisualization] = extractHOGFeatures(I);
% 	% plot(hogVisualization)
% 	% I = imresize(I,.25);
% 	% I = imgaussfilt(I,1.5);
% 	points = detectSURFFeatures(rgb2gray(I),'MetricThreshold',1000);
% 	[f1,vpts1] = extractFeatures(rgb2gray(I),points);
% 	figure(3)
% 	imshow(I)
% 	hold on
% 	if(length(vpts1)>0)
% 		% plot(vpts1(vpts1.Scale>max(vpts1.Scale)-2 ))
% 		plot(vpts1)
% 	end
% 	figure(4)
% 	imshow(I(:,:,2))
	



% end


im_labeler = Image_Labeler('/data');