clc;
clear all;
close all;

P =importdata('movedg1.dat');
w= "P:\sem8\project 3d mapping\im\im_";
w1= "P:\sem8\project 3d mapping\imrgb\irgb_";
image=[];
rgb=[];
 
for j = 1:20:798

    load(sprintf('%s%d',w1,j));
    load(sprintf('%s%d',w,j));
    
    im = zeros(size(i,1),size(i,2),3);

    if (j>=2)
        for v=1:size(i,1)
               for t=1: size(i,2)
                   im(v,t,:) = ([P(j-1,1:3);P(j-1,5:7);P(j-1,9:11)]*[i(v,t,1) i(v,t,2) i(v,t,3)]')+ [P(j-1,4);P(j-1,8);P(j-1,12)] ; 
               end
        end 
    
    else
         
          for v=1:size(i,1)
               for t=1: size(i,2)
                   im(v,t,:) = i(v,t,:);
               end
          end 
        
    end

    
    w2= "P:\sem8\project 3d mapping\iopt\iopt_";
    save(sprintf('%s%d',w2,j),'im');

        image =[image im]; 
        rgb =[rgb iRGB];
    
%      hold on;
%      ptCloud = pointCloud(im,'Color',iRGB);
%      pcshow(ptCloud,'VerticalAxis','Y','VerticalAxisDir','Down');
%      xlabel('X');
%      ylabel('Y');
%      zlabel('Z');
   
end

ptCloud = pointCloud(image,'Color',rgb);
pcwrite(ptCloud,'im3d20mvag.ply','Encoding','ascii');

