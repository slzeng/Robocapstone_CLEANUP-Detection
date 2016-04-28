

classdef Image_Labeler
  
  properties
    image_folder = [];
    image = [];
    points= [];
    segments = [];
    label_image = [];
  end

  methods
    
    %% Image_Labeler: function description
    function [outputs] = Image_Labeler(folder)
      obj.image_folder = folder;

      count = 0;
      name = strcat('data/images/frame',sprintf('%4.4d',count),'.jpg')
      obj.image = imread(name);
      obj.labeled_image()


    end

    function [labeled_image] = label_image(obj)
    	im = single(vl_xyz2lab(vl_rgb2xyz(obj.image)));
    	obj.segments = vl_slic(im,30,1);

    	[sx,sy]=vl_grad(double(obj.segments), 'type', 'forward') ;
      s = find(sx | sy) ;
      obj.imp = I ;
      obj.imp([s s+numel(im(:,:,1)) s+2*numel(im(:,:,1))]) = 0 ;
      figure(1)
      h = imshow(obj.imp);
      set(h,'ButtonDownFcn',@obj.click_callback);
      pause
    end

    function [outputs] = click_callback(obj,handle,event)
      point = event.IntersectionPoint(1:2);
      seg = obj.segments(ceil(point))
      im_segment = obj.imp((imp == 0).*(obj.segments==seg),1) = 1;
    end
  
  end
end