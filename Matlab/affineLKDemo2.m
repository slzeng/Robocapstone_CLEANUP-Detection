% name of the test and data files
%test = 'car';
% test = 'landing';
% dirname = ['../data/', test];
dirname = ['data/','im_7']
% results = ['../results/', test, '.mp4'];
% output = VideoWriter(results, 'MPEG-4');
% output.FrameRate = 15;
% open(output)
figure(1)
clf

%find the images, initialize some variables175:450,450:900,:
nframes = numel(dirlist);

W = eye(3,3);
startFrame = 100;

%loop over the images in the video sequence
for i=startFrame:nframes
    
    %read a new image, convert to double, convert to greyscale
    img = imread(sprintf('%s/%s', dirname, dirlist(i).name));
    img = img(175:450,450:900,:);
    
    % if (ndims(img) == 3)
    %     img = rgb2gray(img);
    % end
    
    img = double(img) / 255;
    %if this is the first image, this is the frame to mark a template on
    if (i == startFrame)

        % preselected regions to track
        % if test(1) == 'c'
        %     %xt1 = 110;
        %     %yt1 = 100;
        %     %xt2 = 350;
        %     % %yt2 = 280;
        %     % xt1 = 120;
        %     % xt2 = 344;
        %     % yt1 = 103;
        %     % yt2 = 280;
        % else
        %     xt1 = 350;
        %     yt1 = 50;
        %     xt2 = 650;
        %     yt2 = 200;
        % end
        imshow(img);

        rect = getrect();
        xt1 = rect(1);
        yt1 = rect(2);
        xt2 = rect(1)+rect(3);
        yt2 = rect(2)+rect(4);

        template = img;
    
        %build a mask defining the extent of the template
        mask     = false(size(template));
        mask(yt1:yt2, xt1:xt2) = true;
        templateBox = [xt1 xt1 xt2 xt2 xt1; yt1 yt2 yt2 yt1 yt1];

        %initialize the LK tracker for this template
        affineLKContext = initAffineLKTracker(template, mask);
    end

    %actually do the LK tracking to update transform for current frame
    W = affineTracker(img, template, mask, W, affineLKContext);
    
    %draw the location of the template onto the current frame, display stuff
    currentBox = W \ [templateBox; ones(1,5)];
    currentBox = currentBox(1:2,:);
    
    hold off;
    imshow(img);
    hold on;
    plot(currentBox(1,:), currentBox(2,:), 'g', 'linewidth', 2);
    drawnow;

    % [X, map] = frame2im(getframe(gca));
    % writeVideo(output, X);
end

% close(output);
