


function gen_weed_message(x,y,I,det_level,fig_count)

	W = 1280;
	H = 720;
	eliminator_offset = .125;
	ppmx = (413.4500/0.3048); % 12 in 
	ppmy = (416/0.3048); % 12 in
	% cam = webcam(1);
	if(strcmp(det_level,'low'))
		pub = rospublisher('/weed_detection',rostype.geometry_msgs_Pose2D);
	else
		pub = rospublisher('/weed_location',rostype.geometry_msgs_Pose2D);
	end
	fig4 = figure(4)
	clf
	h = imshow(I)
	hold on
	plot(x,y,'go')
	plot(W/2,H/2,'rx')
	axis([0 1280 0 720])
	

	x_p = -(y-H/2)/ppmy
	y_p = -(x-W/2)/ppmx

	% Hack to transform to eliminator frame
	if(x_p>=0)
		weed_vector = [x_p,y_p];
		weed_dist = norm(weed_vector) + eliminator_offset
		weed_vector = weed_dist*weed_vector/(norm(weed_vector))
	else
		weed_vector = [-x_p,-y_p];
		weed_dist = -norm(weed_vector) + eliminator_offset
		weed_vector = weed_dist*weed_vector/(norm(weed_vector))
	end
	plot(-weed_vector(2)*ppmx+W/2,-weed_vector(1)*ppmy+H/2,'bx')
	drawnow
	
	weed_location = rosmessage(pub);
	weed_location.X = weed_vector(1)
	weed_location.Y = weed_vector(2)
	send(pub,weed_location);
	clear pub;
	% fig_name = sprintf('data/detected_weeds/weed%d',fig_count);

	% saveas(4,fig_name,'png')


end