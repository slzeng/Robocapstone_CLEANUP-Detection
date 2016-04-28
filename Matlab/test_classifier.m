


% detector = vision.CascadeObjectDetector('weed_detector_2.xml');
name = strcat('data/im_7/frame',sprintf('%4.4d',760),'.jpg')
I = imread(name);

I = I(175:450,451:900,:);
figure(1)
clf
subplot(2,2,1)
h1 = imagesc(zeros(size(I)))
title('Morphology')
% figure(2)
subplot(2,2,2)
h2 = imagesc(zeros(size(I)))
title('Linear SVM')
% figure(3)
subplot(2,2,3)
h3 = imagesc(zeros(size(I)))
title('Combined Morphology and Linear SVM')
subplot(2,2,4)
h4 = imshow(I);
axis tight
hold on
hp = plot([400],[400],'rx');

frame_count = 0;
for(count = 760:1700)
	
	count
	name = strcat('data/im_7/frame',sprintf('%4.4d',count),'.jpg')
	I = imread(name);
	tic
	I = I(175:450,451:900,:);
	% I = I(210:520,380:875,:);
	% I = I(150:425,150:625,:);

	% bbox = step(detector,I);
	% detectedImg = insertObjectAnnotation(I,'rectangle',bbox,'weed');
	% imshow(detectedImg)

	% figure(1)
	% clf
	% imshow(I)
	% im = single(vl_xyz2lab(vl_rgb2xyz(I)));
	% segments = vl_slic(im,1000,100);

		
	% [sx,sy]=vl_grad(double(segments), 'type', 'forward') ;
 %    s = find(sx | sy) ;
 %    imp = I ;
 %    imp([s s+numel(im(:,:,1)) s+2*numel(im(:,:,1))]) = 0 ;
 %    imshow(imp);
	
	% figure(4)
	% clf
	% hold on
	% h = imshow(I);
	set(h4,'AlphaData',.25*ones(size(I(:,:,1))) )
    hold on

    % for(i=0:max(max(segments)))
    % dx = 175;
    % dy = 175;
    % figure(4);
    % subplot(2,2,4)
    % h4 = imshow(I);
    set(h4,'cdata',I)
    % drawnow
    % % pause
    % for(i=1:dx:(size(I,1)-dx))
    % 	for(j=1:dy:(size(I,2)-dy))
    % 		% seg = repmat(segments == i,1,1,3).*double(I)/255;
    % 		seg = I(i:(i+dx),j:(j+dy),:);
	   %  	set(h4,'cdata',seg)
	   %  	drawnow
	   %  	% imshow(repmat(segments == i,1,1,3).*double(I)/255)
	   %  	% pause
	   %  	imagefeatures = (encode(bag,seg));
	   %  	prediction = predict(trainedClassifier,imagefeatures)
		  %   if(prediction == 'Weeds')
		  %   	ad = get(h,'AlphaData');
		  %   	ad(i:(i+dx),j:(j+dy)) = 1;
		  %   	set(h,'AlphaData',ad);
		  %   end
	   % end
    % end
    % figure(3)
    dx = 175;
    dy = 175;
    % x = 1:dx:length(I(:,1,1));
    % y = 1:dy:length(I(1,:,1));
    % x = round(linspace(1,size(I,1)-dx+1,ceil((size(I,1)-dx)/(dx/2))));
    x = 20
	y = round(linspace(1,size(I,2)-dy+1,5));

	ad = .2*ones(size(I(:,:,1)));
	weed_color_detector;
    set(h4,'AlphaData',(.2*ones(size(I(:,:,1)))))
    % figure(4)
    % clf
    % imshow(I)
    % hold on
    for(i=x(1:end))
    	for(j=y(1:end))
			x_cord = i;
			y_cord = j;
		
    		if(i+dx > size(I,1))
    			x_cord = size(I,1)-dx;
    		end
    		if (j+dy > size(I,2))
    			y_cord = size(I,2)-dy;
 			end
    	
    		seg = I(x_cord:(x_cord+dx),y_cord:(y_cord+dy),:);
    		% figure(4)
    		% % clf
    		% imshow(seg)
    		% pause

    		imagefeatures = double(encode(bag,seg));
    		[prediction,xe,mpred] = predict(trainedClassifier,imagefeatures);
			
			if(prediction == 'Weeds')   
	    		ad = get(h4,'AlphaData');
	    		% ad = zeros(size(ad));
			    ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = max((ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy))  + xe(2)/2),.25);
			    set(h4,'AlphaData',ad);
			end
    		% if(prediction == 'Weeds')
		    % 	ad = get(h,'AlphaData');
		    % 	ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) + .15;
		    % 	set(h,'AlphaData',ad);
		    % end
		    % if(prediction == 'Grass')
		    % 	ad = get(h,'AlphaData');
		    % 	ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = max(ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) - .05,.2);
		    % 	set(h,'AlphaData',ad);
		    % end
    	end
    end
    % figure(1)
    % subplot(2,2,1)
    % imagesc(img)
    set(h1,'cdata',img)
    % figure(2)
    % subplot(2,2,2)
    % imagesc(ad)
    set(h2,'cdata',ad)
    ad = img/2 + ad-.25;
	% figure(3)
	% subplot(2,2,3)
	% imagesc(ad)
    set(h3,'cdata',ad)
	
    if(max(max(ad))>=1)
    	num = length(find(ad));
    	if(num>1)
    		[i,j] = find(ad>=1);
    		% figure(4)
    		% subplot(2,2,4)
    		% hold on
    		set(hp,'xdata',mean(j))
    		set(hp,'ydata',mean(i))
    		% plot(mean(j),mean(i),'rx')
    		legend('Weed Position')

    		drawnow

   %  		for(i=1:15)
			% 	fig_name = sprintf('data/detection_movie/frame%04d',frame_count);
			% 	saveas(1,fig_name,'png')
			% 	frame_count = frame_count + 1;
			% end
    		% pause(5)
    	end
    end
	toc
	fig_name = sprintf('data/detection_movie/frame%04d',frame_count);

	saveas(1,fig_name,'png')
	frame_count = frame_count + 1;
    % pause(.1)
    drawnow

	set(hp,'xdata',[])
	set(hp,'ydata',[])
    % pause(.1)
end