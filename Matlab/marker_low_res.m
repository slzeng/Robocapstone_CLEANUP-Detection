% for(count = 100:1700)


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

marker_color_detector
% weed_color_detector;
ad = ad+img;
set(h2,'AlphaData',ad+.2)
    	
drawnow
ad = ad;
if(max(max(ad))>=1)
	num = length(find(ad));
	if(num>2000)
		[i,j] = find(ad>=1);
        vel_msg = rosmessage(rostype.geometry_msgs_Pose2D);
        send(vel_pub,vel_msg);
		gen_weed_message(wl+mean(j),hl+mean(i),Im,'low')
		% figure(3)
		% imshow(ad)
		% figure(2)
		% hold on
		plot(mean(j),mean(i),'rx')

		% % pause()
		% figure(2)
		% clf
		% h2 = imshow(I);
		return
	end
end
toc
