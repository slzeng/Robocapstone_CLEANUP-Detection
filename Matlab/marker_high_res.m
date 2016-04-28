
im_msg = imsub.LatestMessage;
tic
I = readImage(im_msg);

I = I(hl:hu,wl:wu,:);

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
    if(num>1500)
        [i,j] = find(ad>=1);
        Im = readImage(im_msg);
        gen_weed_message(wl+mean(j),hl+mean(i),Im,'high')
        pause()
        figure(3)
        imshow(ad)
        figure(2)
        hold on
        plot(mean(j),mean(i),'rx')

        figure(2)
        clf
        h2 = imshow(I);
        figure(4)
        h4 = imshow(I);
        while(toc < 60)
            fprintf('waiting for elim\n')
            im_msg = receive(imsub);
            I = readImage(im_msg);
            set(h4,'cdata',I)
            drawnow
        end
    end
end
tic

