
im_msg = imsub.LatestMessage;
tic
Im = readImage(im_msg);

I = Im(hl:hu,wl:wu,:);

set(h1,'cdata',I);
set(h2,'cdata',I);
set(h2,'AlphaData',.2*ones(size(I(:,:,1))) )
ad = zeros(size(ad));
dx = 175;
dy = 175;


weed_color_detector;
ad = ad+img/2;
set(h2,'AlphaData',ad+.2)

% x = round(linspace(1,size(I,1)-dx+1,ceil((size(I,1)-dx)/(dx/2))));
% y = round(linspace(1,size(I,2)-dy+1,ceil((size(I,2)-dy)/(dy/2))));
x = 20;
y = round(linspace(1,size(I,2)-dy+1,5));

% for(i=x(1:end))
i = x(1);
for(k=1:length(y(1:end)))
    j = y(k);
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
    	ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = max((ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy))  + xe(2)/2),.2);
    	set(h2,'AlphaData',ad);
    end
    % if(prediction == 'Grass')
    % 	ad = get(h2,'AlphaData');
    % 	ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) = max(ad(x_cord:(x_cord+dx),y_cord:(y_cord+dy)) - .05,.2);
    % 	set(h2,'AlphaData',ad);
    % end
end


drawnow
ad = ad;
if(max(max(ad))>=1)
	num = length(find(ad));
	if(num>2500)
		[i,j] = find(ad>=1);
        vel_msg = rosmessage(rostype.geometry_msgs_Pose2D);
        send(vel_pub,vel_msg);
		gen_weed_message(wl+mean(j),hl+mean(i),Im,'low',weed_kill_count)
		weed_kill_count = weed_kill_count + 1;
		figure(3)
		imagesc(ad)
		figure(2)
		hold on
		plot(mean(j),mean(i),'rx')
		% pause()
		% figure(2)
		% clf
		% h2 = imshow(I);
		return
	end
end
toc
