



v = VideoReader('phone_video_4.avi');
folder = 'data/im_6/'

count = 0;
while hasFrame(v)
	name = strcat(folder,sprintf('image%d',count),'.png');
	video = readFrame(v);
	imshow(video);
	drawnow
	imwrite(video,name);
	count = count + 1;
	pause(.05)
end