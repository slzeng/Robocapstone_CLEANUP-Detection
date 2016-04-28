


% D = dir(['data/images/', '\*.jpg']);
% n = length(D(not([D.isdir])))
count = 0;
for(i=1:length(positiveInstances))
	name = positiveInstances(i).imageFilename;
	I = imread(name);
	for(j = 1:length(positiveInstances(i).objectBoundingBoxes(:,1)))
		bbox = positiveInstances(i).objectBoundingBoxes(j,:);
		roi = I(bbox(2):bbox(2)+bbox(4)-1,bbox(1):bbox(1)+bbox(3)-1,:);
		str = sprintf('data/WeedData/Weeds/weed%d.png', count);
		imwrite(roi,str);
		count = count +1;
	end

end

count = 0;
for(i=1:length(negitiveInstances))
	name = negitiveInstances(i).imageFilename;
	I = imread(name);
	for(j = 1:length(negitiveInstances(i).objectBoundingBoxes(:,1)))
		bbox = negitiveInstances(i).objectBoundingBoxes(j,:);
		roi = I(bbox(2):bbox(2)+bbox(4)-1,bbox(1):bbox(1)+bbox(3)-1,:);
		str = sprintf('data/WeedData/Grass/grass%d.png', count);
		imwrite(roi,str);
		count = count +1;
	end

end