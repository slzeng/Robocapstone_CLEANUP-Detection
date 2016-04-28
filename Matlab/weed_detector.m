
function [] = weed_detector(I)
	
	hl = 225; 
	hu = 500;
	wl = 500;
	wu = 825;

	I = I(hl:hu,wl:wu,:);

	figure(1)
	clf
	h1 = imshow(I);
	figure(2)
	clf
	h2 = imshow(I)

	set(h1,'cdata',I);
	set(h2,'cdata',I);
	set(h2,'AlphaData',.2*ones(size(I(:,:,1))) )
    dx = 175;
    dy = 175;

	x = 20
	y = round(linspace(1,size(I,2)-dy+1,5));

	img = weed_color_detector(I);
    set(h2,'AlphaData',img/2+.2)
	    	

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
    		
    		imagefeatures = double(encode(bag,seg));
    		[prediction,xe,mpred] = predict(trainedClassifier,imagefeatures);
    		% figure(4)
    		% clf
    		% imshow(seg)
    		% pause


    		if(prediction == 'Weeds')
	    		ad = get(h2,'AlphaData');
		    	ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = max((ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy))  + xe(2))/3,.2);
		    	set(h2,'AlphaData',ad);
		    end
		    % if(prediction == 'Grass')
		    % 	ad = get(h2,'AlphaData');
		    % 	ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = max(ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) - .05,.2);
		    % 	set(h2,'AlphaData',ad);
		    % end
    	end
    end
    drawnow
    ad = ad-.2;
    if(max(max(ad))>=1)
    	num = length(find(ad));
    	if(num>1)
    		[i,j] = find(ad>=1);
    		figure(3)
    		imshow(ad)
    		figure(2)
    		hold on
    		plot(mean(j),mean(i),'rx')

    		pause()
    		figure(2)
    		clf
    		h2 = imshow(I);
    	end
    end
end