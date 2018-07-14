clc;
clear all;
P =importdata('optposeslm.dat');


srcFiles = dir('P:\sem8\rgbd_dataset_freiburg1_xyz\depth\*.png'); 
for i=1:length(srcFiles)   
timestamp=(srcFiles(i).name(1:17));
trans =[P(i,5),P(i,9),P(i,13)];
rot = [P(i,2:4); P(i,6:8); P(i,10:12)];
quat = [circshift(rotm2quat(rot),1)];
traj =[timestamp ' ' num2str(trans) ' ' num2str(quat)];
dlmwrite('trajectorylm.txt' ,traj,'-append','delimiter','');
end


