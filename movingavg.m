load optposes1.dat

for i=1:size(optposes1,1)
   
    if (i==1)|| (i==size(optposes1,1))
         P = optposes1(i,:);
    else
         P = (optposes1(i-1,:)+ optposes1(i,:)+optposes1(i+1,:))/3 ;
    end
  
    save movavgposes1.dat P -ASCII -append
end
 