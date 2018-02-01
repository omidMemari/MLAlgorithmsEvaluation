function [means, covs, pri ] = Naive_tr( train,labtr,c )
%NAIVE Summary of this function goes here
%   Detailed explanation goes here
pri=zeros(c,1);
str=size(train);
covs=zeros(c,str(2));
means=zeros(c,str(2));
for i=1:c
    si=sum(labtr==i); %% dadehaye kelse i om
    pri(i,1)=si/str(1);
    train_i=train(labtr==i,:);
    means(i,:)=mean(train_i);
    covs(i,:)=var(train_i);
end
end

