clc;
close all;


srcFilesRGB = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\*.png');  % the folder in which ur images exists
 
for j = 1:length(srcFilesRGB)

    iRGB = imread(strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(j).name));
    w= "P:\sem8\project 3d mapping\imrgb\irgb_";
    save(sprintf('%s%d',w,j),'iRGB');
    
end