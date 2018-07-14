clc;
clear all;

P =importdata('transform2.txt');

for i=2:size(P,1)
   
    Tinv{i-1}= [P(1,1:4);P(1,5:8);P(1,9:12);0 0 0 1]* (inv([P(i,1:4);P(i,5:8);P(i,9:12);0 0 0 1]));
    t=Tinv{i-1}';
    ted = [t(:)]';
    
    save optedg2.dat ted -ASCII -append
end