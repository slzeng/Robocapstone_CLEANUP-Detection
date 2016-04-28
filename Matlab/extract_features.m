



for(count = 1:length(positiveInstances))
	name = positiveInstances(count).imageFilename;
	I = imread(name);
	% I = I(210:520,380:875,:);

	for(i = 1:length(positiveInstances(count).objectBoundingBoxes(:,1)))
		bbox = positiveInstances(count).objectBoundingBoxes(i,:);
		roi = I(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
		figure(1)
		imshow(roi)
		
		% segments = vl_slic(single(im),30,1);
		
		% [sx,sy]=vl_grad(double(segments), 'type', 'forward') ;
	 %    s = find(sx | sy) ;
	 %    imp = I ;
	 %    imp([s s+numel(im(:,:,1)) s+2*numel(im(:,:,1))]) = 0 ;
	 %    imshow(imp);
		figure(2)
		clf
		imshow(roi)
		hold on
		[featureVector, hogVisualization] = extractHOGFeatures(roi);
		plot(hogVisualization)
		% I = imresize(I,.25);
		% I = imgaussfilt(I,1.5);
		% points = detectSURFFeatures(rgb2gray(roi),'MetricThreshold',500);
		% [f1,vpts1] = extractFeatures(rgb2gray(roi),points);
		% [r,f] = vl_mser(uint8(rgb2gray(roi)),'MinDiversity',0.7,'MaxVariation',0.2,'Delta',10) ;
		figure(3)
		clf
		imshow(roi)
		hold on
		% f = vl_covdet(im2single(rgb2gray(roi)), 'verbose');
		% vl_plotframe(f);
		binSize = 1;
		magnif = .0001;
		[f, d] = vl_phow(im2single(rgb2gray(roi)));
		% drawnow
		% f(3,:) = binSize/magnif ;
		% f(4,:) = 0 ;
		% f = vl_ertr(f);
		vl_plotframe(f);

		% if(length(vpts1)>0)
		% 	% plot(vpts1(vpts1.Scale>max(vpts1.Scale)-2 ))
		% 	plot(vpts1)
		% end
		% figure(4)
		% imshow(I(:,:,2))
		pause

	end
end
