clc;
clear all;

P =importdata('movavgposes1.dat');

for i=2:size(P,1)
   
    Tinv{i-1}= [P(1,2:5);P(1,6:9);P(1,10:13);0 0 0 1]* (inv([P(i,2:5);P(i,6:9);P(i,10:13);0 0 0 1]));
    t=Tinv{i-1}';
    ted = [t(:)]';
    
    save movedg1.dat ted -ASCII -append
end