
clc;
clear all;
close all;

b=1;
srcFilesRGB = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\*.png');  % the folder in which ur images exists
fileRGB1 = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(1).name);
I{1} = rgb2gray(imread(fileRGB1));
points{1} = detectSURFFeatures(I{1});
[f{1},vpts{1}] = extractFeatures(I{1},points{1});
Keyframe(b)=1;

    
for i = 2:(length(srcFilesRGB))
    fileRGB = strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(i).name);
    I{i}= rgb2gray(imread(fileRGB));  
    points{i} = detectSURFFeatures(I{i});
    [f{i},vpts{i}] = extractFeatures(I{i},points{i});
    
    if(b==1)
    [indexPairs,matchmetric] = matchFeatures(f{Keyframe(1)},f{i},'MaxRatio',0.40,'Metric','SSD','Unique',true); 
     ratio =size(indexPairs,1) /size(vpts{1},1);
%    Find keyframes  
            if (ratio <0.05)
                  b=b+1;
                  Keyframe(b)= i;
            end
    end  
       
     if(b>1)
         for count=1:b
          [indexPairs,matchmetric] = matchFeatures(f{Keyframe(count)},f{i},'MaxRatio',0.40,'Metric','SSD','Unique',true); 
          ratio(count)  = size(indexPairs,1)/size(vpts{count},1);
         end
     k = nnz(ratio <0.05);   
%    Find keyframes  
            if ( k== b)
                  b=b+1;
                  Keyframe(b)= i;
            end
    end  
    
    end
     
save('keyframe.mat','Keyframe');
      
     
     
     
     
  


   