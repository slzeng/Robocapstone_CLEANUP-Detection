url = 'http://192.0.0.4:8080/shot.jpg';
cam = imread(url);
img = image(cam);

v = VideoWriter('phone_video.avi');
v.FrameRate = 6;
open(v);
size(cam)

tic;
while(toc < 30)
    t0 = toc;
    cam = imread(url);
    writeVideo(v,cam);
    set(img,'CData',cam);
    drawnow;
    t1 = toc;
    sprintf('Frame Rate:%f',1/(t1-t0))
end


close(v);