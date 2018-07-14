clc;
clear all;
close all;

kf=importdata('keyframe.mat') ;


srcFilesRGB = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\*.png');  % the folder in which ur images exists
    
for i = 1:(length(srcFilesRGB))
   if (ismember(i,kf))
    fileRGB = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(i).name);
    I{i}= rgb2gray(imread(fileRGB));  
    points{i} = detectSURFFeatures(I{i});
    [f{i},vpts{i}] = extractFeatures(I{i},points{i});
	end
end

for  i = 1:(length(srcFilesRGB))

	if ~(ismember(i,kf))
        fileRGB = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(i).name);
        I{i}= rgb2gray(imread(fileRGB));  
        points{i} = detectSURFFeatures(I{i});
        [f{i},vpts{i}] = extractFeatures(I{i},points{i});
	for count = 1:size(kf,2)
        l=kf(1,count);
	    [indexPairs,matchmetric] = matchFeatures(f{l},f{i},'MaxRatio',0.40,'Metric','SSD','Unique',true); 
	      ratio(count)  = size(indexPairs,1)/size(vpts{i},1);
    end
	    k = find(ratio> 0.90);
              
  if(~isempty(k))   
      
fx = 525.0  ; % focal length x
fy = 525.0  ; % focal length y
cx = 319.5  ; % optical center x
cy = 239.5  ; % optical center y
factor = 5000 ; % for the 16-bit PNG files

srcFilesDepth = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\*.png'); 
inf =[1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 1];


for h=1:size(k,2)
    clear location{i};
    clear location{kf(1,k(h))};
    [indexPairs,matchmetric] = matchFeatures(f{kf(1,k(h))},f{i},'MaxRatio',0.40,'Metric','SSD','Unique',true);
    matchedPoints{i} = vpts{i}(indexPairs(:,1));
    location{i} = round(matchedPoints{i}.Location);
    matchedPoints{kf(1,k(h))} = vpts{kf(1,k(h))}(indexPairs(:,2));
    location{kf(1,k(h))} = round(matchedPoints{kf(1,k(h))}.Location);
    

%     choose 3D coordinates of matched points
r=[i kf(1,k(h))]
    for q=1:size(r,2)
        w = r(q);
        %     depth information
    fileDepth1 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\',srcFilesDepth(i).name);
    fileDepth2 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\',srcFilesDepth(w).name);
    D{i} = imread(fileDepth1);
    D{w} = imread(fileDepth2);
        d= D{w};
        im{w}= zeros(size(d,1),size(d,2),3);
        imf{w}=zeros(size(location{1,w},1),3);

              for v=1:size(im{w},1)
                  for t=1: size(im{w},2)
                    im{w}(v,t,3) = double(d(v,t))/double(factor);
                    im{w}(v,t,1) = (t - cy) * im{w}(v,t,3)/fy;
                    im{w}(v,t,2) = (v - cx) * im{w}(v,t,3)/fx;
                  end
              end
              
                     for u=1:size(location{1,w},1)
%                     im{w}(location{1,w}(u,2),location{1,w}(u,1),3) = double(d(location{1,w}(u,2),location{1,w}(u,1)))/double(factor);
                    imf{w}(u,3) = im{w}(location{1,w}(u,2),location{1,w}(u,1),3);
%                     im{w}(location{1,w}(u,2),location{1,w}(u,1),1) = (location{1,w}(u,2) - cy) * im{w}(location{1,w}(u,2),location{1,w}(u,1),3)/fy;
                    imf{w}(u,1) = im{w}(location{1,w}(u,2),location{1,w}(u,1),1);
%                     im{w}(location{1,w}(u,2),location{1,w}(u,1),2) = (location{1,w}(u,1) - cx) * im{w}(location{1,w}(u,2),location{1,w}(u,1),3)/fx;
                    imf{w}(u,2) = im{w}(location{1,w}(u,2),location{1,w}(u,1),2);
                        end
                    
      
            
%    formulate the transformation using ransac method 

    tRAN = cv.estimateAffine3D(imf{1,i},imf{1,kf(1,k(h))},'Confidence',0.99);
    tRANSAC = [tRAN;0 0 0 1];
    rot = tRANSAC(1:3,1:3);
    tr =[tRANSAC(1:3,4)' rotm2eul(rot)];
    e = [i kf(1,k(h)) tr inf];
    save edges1.mat e -ASCII -append   
    end
              
end
           end
   end
end
