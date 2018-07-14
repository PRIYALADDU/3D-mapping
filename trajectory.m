edg =importdata('poses1.dat');
length=1;

v= [double(edg(:,2)) double(edg(:,3)) double(edg(:,4))]*10^-3;

   XX=v(:,1)';
   YY=v(:,2)';
   ZZ=v(:,3)';
   
plot3(XX,YY,ZZ,'LineWidth',3);
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal



