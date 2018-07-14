srcFilesRGB = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\*.png');  % the folder in which ur images exists
srcFilesDepth = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\*.png'); 

mkdir('P:\sem8\rgbd_data\rgb\');
mkdir('P:\sem8\rgbd_data\depth\');

desFilesRGB = dir('P:\sem8\rgbd_data\rgb\');
desFilesDepth= dir('P:\sem8\rgbd_data\depth\');

for i = 1:length(srcFilesRGB)
    [pathstr, new_file_name, ext] = fileparts(strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(i).name));
    fileRGB = imread(strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\rgb\',srcFilesRGB(i).name));
    new_file_name=strcat('P:\sem8\rgbd_data\rgb\', new_file_name, '.ppm');
    imwrite(fileRGB,new_file_name,'ppm');
    
    
    [pathstr1, new_file_name1, ext1] = fileparts(strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\',srcFilesDepth(i).name));
    fileDepth = imread(strcat('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\',srcFilesDepth(i).name));
    new_file_name1=strcat('P:\sem8\rgbd_data\depth\', new_file_name1, '.pgm');
    imwrite(fileDepth,new_file_name1,'pgm')
end
