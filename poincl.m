clc;

w1= "P:\sem8\project 3d mapping\imrgb\irgb_";
w2= "P:\sem8\project 3d mapping\iopt\iopt_";

r=1;

field1='location';
field2='rgb';
field3='count';

for k=1:798
    
    load(sprintf('%s%d',w1,k));
    load(sprintf('%s%d',w2,k));
if (k==1)
    for v= 1: size(im,1)
        for t=1: size(im,2)
           location = [im(v,t,:)];
           rgb=[iRGB(v,t,:)];
           count= 1;
           s(r) =struct(field1,location,field2,rgb,field3,count);
           r=r+1;
        end
    end  
else
     for v= 1: size(im,1)
         for t=1: size(im,2)
           location = [im(v,t,:)];
           rgb=[iRGB(v,t,:)];
           count= 1;
           s(r) =struct(field1,location,field2,rgb,field3,count);
           r=r+1;
         end
      end
    
end
    
end