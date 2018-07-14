clc;
clear all;
close all;

fx = 525.0  ; % focal length x
fy = 525.0  ; % focal length y
cx = 319.5  ; % optical center x
cy = 239.5  ; % optical center y
factor = 5000 ; % for the 16-bit PNG files

srcFilesRGB = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\*.png');  % the folder in which ur images exists
srcFilesDepth = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\*.png'); 
for i = 1:2%(length(srcFilesRGB)-1)
    clear location{i};
    clear location{i+1};
    fileRGB1 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(100).name);
    fileRGB2 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(101).name);
    I1 = rgb2gray(imread(fileRGB1));  
    I2 = rgb2gray(imread(fileRGB2));
    points1 = detectSURFFeatures(I1);
    points2 = detectSURFFeatures(I2);
    
    [f1,vpts1] = extractFeatures(I1,points1);
    [f2,vpts2] = extractFeatures(I2,points2);
    [indexPairs,matchmetric] = matchFeatures(f1,f2,'MaxRatio',0.40,'Metric','SSD','Unique',true);
    
   
    matchedPoints{i} = vpts1(indexPairs(:,1));
    location{i} = round(matchedPoints{i}.Location);
    matchedPoints{i+1} = vpts2(indexPairs(:,2));
    location{i+1} = round(matchedPoints{i+1}.Location);
    
%     figure; imshow(I1); hold on
%       plot(vpts1);
%     
%    figure; ax = axes;showMatchedFeatures(I1,I2,matchedPoints{1},matchedPoints{2},'montage','Parent',ax);
%    title(ax, 'Candidate point matches');
%    legend(ax, 'Matched points 1','Matched points 2');
%    
%     depth information
    fileDepth1 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\',srcFilesDepth(i).name);
    fileDepth2 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\',srcFilesDepth(i+1).name);
    D{i} = imread(fileDepth1);
    D{i+1} = imread(fileDepth2);


%     choose 3D coordinates of matched points
%     converge everything into N X 3 array

    for w=i:i+1
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
                    
       end
         

%    formulate the transformation using ransac method 

 tRANSAC{i} = cv.estimateAffine3D(imf{1,i},imf{1,i+1},'Confidence',0.99);
 
 
end

