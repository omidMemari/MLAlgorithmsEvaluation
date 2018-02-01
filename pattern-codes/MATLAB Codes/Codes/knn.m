function [mis cpre] = knn(test,labts,train,labtr)
%KNN Summary of this function goes here
%   Detailed explanation goes here
str=size(train);
sts=size(test);
cpre=zeros(sts(1),1);
for i=1:sts(1)
    x=train-repmat(test(i,:),str(1),1);
    dist=sum(x.*x,2);
    [~,ind]=min(dist);
    cpre(i,1)=labtr(ind);
end
mis=(cpre~=labts);
end

