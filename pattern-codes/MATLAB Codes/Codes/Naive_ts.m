function  [mis cpre]=Naive_ts(data,lab,means ,covs ,pri,c)
%NAIVE_TS Summary of this function goes here
%   Detailed explanation goes here
s=size(data);
cpre=zeros(s(1),1);
for i=1:s(1)
     feai=data(i,:);
     v=zeros(c,1);
     for k = 1:c
            d = feai - means(k,:);
            v(k,1) = sum(-0.5*d.*d./covs(k,:) - 0.5*log(covs(k,:)), 2) + log(pri(k));
     end
     [cn,j] = max(v);
     cpre(i,1) = j;
end
mis=(cpre~=lab);
end

