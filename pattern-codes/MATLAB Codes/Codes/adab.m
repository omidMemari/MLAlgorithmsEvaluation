function [trerr, tserr] = adab(T,train,labtr,test,labts,c,type)
%ADAB Summary of this function goes here
%   Adaboost
str=size(train);
sts=size(test);
w=1/str(1)*ones(str(1),1);
%%%%%%%%%%%%%%%%%%% Training
switch type
    case 'naive'
        i=1;
        flag=1;
        while(i<T+1)
            p=w/sum(w);
            [train_n labtr_n ]=Makedata(train,labtr,p);
            [means, covs, pri] = Naive_tr(train_n,labtr_n,c);
            [mis_tr, cpre_tr] = Naive_ts(train,labtr, means, covs, pri,c);
            [mis_ts, cpre_ts] = Naive_ts(test,labts, means, covs, pri,c);
            e=sum(p.*mis_tr);
            if(e>0.5)
%                 disp('Error is greater than 0.5 naive');
%                 disp('Iteration: ');
%                 disp(i);
                flag=0;
            else flag=1;
            end
            if(flag==1)
                b(i)=e/(1-e);
                if (b(i) == 0)
                    b(i) = 1e-8;
                end
                w=w.*b(i).^(1-mis_tr);
                cpre_tr_all(:,:,i)=cpre_tr;
                cpre_ts_all(:,:,i)=cpre_ts;
                mis_tr_all(:,:,i)=mis_tr;
                mis_ts_all(:,:,i)=mis_ts;
                i=i+1;
            end
        end
    case 'knn'
        i=1;
        flag=1;
        while(i<T+1)
            p=w/sum(w);
            [train_n labtr_n ]=Makedata(train,labtr,p);
            [mis_tr, cpre_tr] = knn(train,labtr,train_n,labtr_n);
            [mis_ts, cpre_ts] = knn(test,labts,train_n,labtr_n);
            e=sum(p.*mis_tr);
            if(e>0.5)
%                 disp('Error is greater than 0.5 knn');
%                 disp('Iteration: ');
%                 disp(i);
                flag=0;
            else flag=1;
            end
            if(flag==1)
                b(i)=e/(1-e);
                if (b(i) == 0)
                    b(i) = 1e-8;
                end
                w=w.*b(i).^(1-mis_tr);
                cpre_tr_all(:,:,i)=cpre_tr;
                cpre_ts_all(:,:,i)=cpre_ts;
                mis_tr_all(:,:,i)=mis_tr;
                mis_ts_all(:,:,i)=mis_ts;
                i=i+1;
            end
        end
    case 'svm'
        i=1;
        flag=1;
        while(i<T+1)
            p=w/sum(w);
            [train_n labtr_n ] = Makedata(train,labtr,p);
            [SVMStruct] = svm_tr(train_n,labtr_n);
            [mis_tr, cpre_tr] = svm_ts(train,labtr,SVMStruct);
            [mis_ts, cpre_ts] = svm_ts(test,labts,SVMStruct);
            e=sum(p.*mis_tr);
            if(e>0.5)
%                 disp('Error is greater than 0.5 svm');
%                 disp('Iteration: ');
%                 disp(i);
                flag=0;
            else flag=1;
            end
            if (flag==1)
                b(i)=e/(1-e);
                if (b(i) == 0)
                    b(i) = 1e-8;
                end
                w=w.*b(i).^(1-mis_tr);
                cpre_tr_all(:,:,i)=cpre_tr;
                cpre_ts_all(:,:,i)=cpre_ts;
                mis_tr_all(:,:,i)=mis_tr;
                mis_ts_all(:,:,i)=mis_ts;
                i=i+1;
            end
        end
        %%%%%
end
%%%%%%%%%%%   Evaluating
% disp('************************************************');
% disp('************************************************');
tr_res=zeros(str(1),1);
for j=1:T
    for i=1:str(1)
        v=zeros(11,1);
        for t=1:j
            if(mis_tr_all(i,:,t)==0)
                v(cpre_tr_all(i,:,t),1)=v(cpre_tr_all(i,:,t),1)+log10(1/b(t));
            end
        end
        [cn,argmax] = max(v);
        tr_res(i,1) = argmax;
    end
    tr_err = (tr_res ~= labtr);
    trerr(j,1) = sum(tr_err)/str(1);
%     fprintf(1, 'Training error of %s is %f\n',type, trerr(j,1));
end
% disp('************************************************');
% disp('************************************************');
%%%%%%%%%%%%%%%%%%%%%%%%%%
ts_res=zeros(sts(1),1);
for j=1:T
    for i=1:sts(1)
        v=zeros(11,1);
        for t=1:j
            if(mis_ts_all(i,:,t)==0)
                v(cpre_ts_all(i,:,t),1)=v(cpre_ts_all(i,:,t),1)+log10(1/b(t));
            end
        end
        [~,argmax] = max(v);
        ts_res(i,1) = argmax;
    end
    ts_err = (ts_res ~= labts);
    tserr(j,1) = sum(ts_err)/sts(1);
%     fprintf(1, 'Testing error of %s is %f\n',type,tserr(j,1));
end
% disp('************************************************');
% disp('************************************************');
end

