


function detection_callback(src,msg)
	msg
	figure(1)
	I = readImage(msg);
	imshow(I)
	fprintf('HELLO WORLD')
	drawnow
end