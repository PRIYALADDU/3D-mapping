load xyzeuler.txt
for i=1:size(xyzeuler,2)
    M(i) = mean(xyzeuler(:,i));
end

for i= 1: size(xyzeuler,2)
      for j= 1: size(xyzeuler,2)
              cov(i,j) = (xyzeuler(:,j)-M(j))'*(xyzeuler(:,i)-M(i))/size(xyzeuler,1);
      end
end

invcov = inv(cov);

save inf.txt invcov -ASCII