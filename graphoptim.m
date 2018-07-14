clc
clear
addpath('P:\sem8\project 3d mapping\g2o-matlab-master\g2o_VINS\g2o_files\');
addpath('P:\sem8\project 3d mapping\g2o-matlab-master\g2o_VINS\Math\');
addpath('P:\sem8\project 3d mapping\g2o-matlab-master\g2o_VINS\Factor\');

load poses1.dat;
load edges1.dat;
load transform1.txt;
% load inf.txt;

[ Graph ] = InitializeGraph;

Num_edge= size(edges1,1);

j=1;

while    (j<=Num_edge)
    
      Factor_ThisStep='RelativePose3_Factor';
      from_pose_id =['pose' num2str( edges1(j,1) )];  
      to_pose_id=['pose'  num2str( edges1(j,2) )];
      
      Measurement.value=[transform1(j,1:4);transform1(j,5:8);transform1(j,9:12);transform1(j,13:16);]*10^-3;
      Measurement.inf= [10^6 0 0 0 0 0;0 10^6 0 0 0 0;0 0 10^6 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1] ;
%       Measurement.inf= inf;
      [ Graph ] = AddNormalEdge( Graph, Factor_ThisStep, 'Pose3', from_pose_id,  'Pose3', to_pose_id, Measurement );
   
      j=j+1;
end 
 
TypeName_this= 'RelativePose3_Factor';
  
%%%% optimization
[ Graph ] = PerformGO_LM(Graph)
%%% plot
PoseArray = fields(Graph.Nodes.Pose3.Values);
Num_poses= size(PoseArray,1);
XX=[];
YY=[];
ZZ=[];
for i=1:Num_poses
    
   ThisPose_id=  PoseArray{i};
   
   ThisPose_value=Graph.Nodes.Pose3.Values.(ThisPose_id);
   
   ThisPose_position=ThisPose_value(1:3,3);
   
   t=ThisPose_value';
   
 ThisPose =[i t(:)'];
   
   x=ThisPose_position(1);
   y=ThisPose_position(2);
   z=ThisPose_position(3);
    
   XX=[XX x];
   YY=[YY y];
   ZZ=[ZZ z];
  save optposeslm.dat ThisPose  -ASCII -append  
end

plot3(XX,YY,ZZ,'LineWidth',3);
xlabel('X');
ylabel('Y');
zlabel('Z');


