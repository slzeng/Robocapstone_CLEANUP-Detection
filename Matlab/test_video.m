


v = VideoReader('phone_video_1.avi');



while hasFrame(v)
	video = readFrame(v);
	imshow(video);
	drawnow
	pause	
end