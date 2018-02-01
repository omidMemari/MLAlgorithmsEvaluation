function [train_n labtr_n] = Makedata(train,labtr,p )
% make data mfile
% This codes makes a train data using distribution p
%%%
if(sum(p)>1.01 || sum(p)<.99)
    disp('Error 1: Sum of p(distribution) is not one!');
    format long;
    sum(p)
    format short;
    return;
end
 s=size(train);
 train_n=[];
 labtr_n=[];
for i=1:s(1)
    a=rand;
    summ=0;
    j=0;
    while(summ<a)
        j=j+1;
        summ=summ+p(j);
    end
    train_n=[train_n ;train(j,:)];
    labtr_n=[labtr_n ;labtr(j,:)];
end



end

