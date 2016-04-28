% clear all



figure(1)
clf
hold on
W = 1280;
H = 720;
eliminator_offset = .125;
ppmx = (413.4500/0.3048); % 12 in 
ppmy = (416/0.3048); % 12 in
% cam = webcam(1);
pub = rospublisher('/weed_location');
sub = rossubscriber('usb_cam/image_raw');
msg = receive(sub);
h = imshow(readImage(msg));
drawnow
plot(W/2,H/2,'rx')
axis([0 1280 0 720])
[x,y] = ginput(1)


x_p = -(y-H/2)/ppmy
y_p = -(x-W/2)/ppmx

% Hack to transform to eliminator frame
weed_vector = [x_p,y_p];
weed_dist = norm(weed_vector) + eliminator_offset;
weed_vector = weed_dist*weed_vector/(norm(weed_vector));

weed_location = rosmessage(pub);
weed_location.X = weed_vector(1);
weed_location.Y = weed_vector(2);
send(pub,weed_location);
clear pub;
tic
while(toc < 60)
	msg = receive(sub);
	I = readImage(msg);
	set(h,'cdata',I)
	drawnow
end