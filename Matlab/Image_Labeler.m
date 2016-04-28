

classdef Image_Labeler < handle
  
  properties
    image_folder = [];
    image = [];
    points= [];
    segments = [];
    image_labels = [];
    imp = [];
    h_image;
    h_labels;
    selected_segments = [];
    labeled_images = [];
  end

  methods
    
    %% Image_Labeler: function description
    function [obj] = Image_Labeler()
      % obj.image_folder = folder;
      count = 1; 
      for(i = 40:5:100)
      % i = 0;
        name = strcat('data/images/frame',sprintf('%4.4d',i),'.jpg')
        obj.image = imread(name);
        obj.image = obj.image(210:520,380:875,:);
        obj.image_labels = ones(size(obj.image(:,:,1)));
        obj.label_image()
        obj.write_weed_images()
        % obj.labeled_images(count).data = (obj.image_labels~=1);
        % obj.labeled_images
        count = count + 1;
      end

    end


    %% write_weed_images: function description
    function [] = write_weed_images(obj)
      weeds = double(obj.image).*repmat((obj.image_labels~=1),1,1,3)/255;
      size(weeds)
      % weeds =  weeds(any(weeds~=0));

      [I,J] = find(round(weeds(:,:,1)));
      min(I)
      max(I)
      min(J)
      max(J)
      weeds = weeds(min(I):max(I),min(J):max(J),:);
      figure(1)
      clf
      size(weeds)

      imshow(weeds)
      pause
    end    


    function [] = label_image(obj)
    	im = single(vl_xyz2lab(vl_rgb2xyz(obj.image)));
    	obj.segments = vl_slic(single(obj.image),80,50000);

    	[sx,sy]=vl_grad(double(obj.segments), 'type', 'forward') ;
      s = find(sx | sy) ;
      obj.imp = obj.image ;
      obj.imp([s s+numel(im(:,:,1)) s+2*numel(im(:,:,1))]) = 0 ;
      figure(2)
      imshow(obj.image)
      figure(1)
      clf
      hold on
      obj.h_image = imshow(obj.image);
      set(obj.h_image,'ButtonDownFcn',@obj.click_callback);
      % obj.h_labels = imshow(obj.image_labels);
      % set(obj.h_labels,'AlphaData',0);

      pause
    end

    function [] = click_callback(obj,handle,event)
      % testpt = get(handle.axesImage,'CurrentPoint')
      point = event.IntersectionPoint(1:2)
      seg = obj.segments(ceil(point(2)),ceil(point(1)))
      if(any(obj.selected_segments == seg))
        idx = find(obj.selected_segments == seg);
        obj.selected_segments = obj.selected_segments(obj.selected_segments~=seg);
        obj.image_labels(obj.segments == seg) = 1;
        
      else
        obj.selected_segments(end+1) = seg;
        % size((obj.imp(:,:,1) == 0))
        % size(obj.segments==seg)
        obj.image_labels(obj.segments == seg) = .25;
      end
      obj.selected_segments
      set(obj.h_image,'AlphaData',obj.image_labels);

    end
  end
end