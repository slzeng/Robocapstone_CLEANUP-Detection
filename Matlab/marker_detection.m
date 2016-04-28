


% detector = vision.CascadeObjectDetector('weed_detector_2.xml');
imsub = rossubscriber('usb_cam/image_raw');
level_sub = rossubscriber('detection_level',rostype.std_msgs_String);
vel_pub = rospublisher('/cmd',rostype.geometry_msgs_Pose2D)
detection_level = 'low';
det_msg = level_sub.LatestMessage;

im_msg = imsub.LatestMessage;
while(length(im_msg)<1)
	fprintf('Waiting for image data...\n')
	pause(.1)
	im_msg = imsub.LatestMessage;
end
I = readImage(im_msg);
max_queue = [0 0 0 0 0];
count = 1;
hl = 175; 
hu = 600;
wl = 376;
wu = 815;

I = I(hl:hu,wl:wu,:);

figure(1)
clf
h1 = imshow(I);
figure(2)
clf
h2 = imshow(I)
ad = get(h2,'AlphaData');


while(true)
	det_msg = level_sub.LatestMessage;
	if(length(det_msg)>0)
		detection_level = det_msg.Data
	end

	if(strcmp(detection_level,'low'))
		marker_low_res;
	else
		marker_high_res;
	end
end

