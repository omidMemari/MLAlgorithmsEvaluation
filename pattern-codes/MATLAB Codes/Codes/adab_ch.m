function [trerr, tserr] = adab_ch(T,train,labtr,test,labts,c,type)
%ADAB Summary of this function goes here
%   Adaboost
str=size(train);
sts=size(test);
w=1/str(1)*ones(str(1),1);
E=zeros(T,str(1));
B=zeros(T,str(1));
e=zeros(T,1);
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
            E(i,:)=~(mis_tr');
            e(i)=sum(p.*mis_tr);
            if(e(i)>0.5)
                disp('Error is greater than 0.5 ch');
                disp('Iteration: ');
                disp(i);
                flag=0;
            else flag=1;
            end
            if(flag==1) %%age error az 0.5 kamtar bood abjam bede
            b(i)=e(i)/(1-e(i));
            summ=zeros(1,str(1));
            for k=1:i
                summ=summ+E(k,:)*(e(k)^-1);
            end
            for j=1:str(1)
                if(summ(1,j)~=0)
                    B(i,j)=1/summ(1,j);
                else
                    B(i,j)=1;
                end
            end
            %w=w.*b(i).^(1-mis_tr);
            w=w.*B(i,:)';
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
            E(i,:)=~(mis_tr');
            e(i)=sum(p.*mis_tr);
            if(e(i)>0.5)
                disp('Error is greater than 0.5 ch');
                disp('Iteration: ');
                disp(i);
                flag=0;
            else flag=1;
            end
            if (flag==1)
            b(i)=e(i)/(1-e(i));
            summ=zeros(1,str(1));
            for k=1:i
                summ=summ+E(k,:)*(e(k)^-1);
            end
            for j=1:str(1)
                if(summ(1,j)~=0)
                    B(i,j)=1/summ(1,j);
                else
                    B(i,j)=1;
                end
            end
            %w=w.*b(i).^(1-mis_tr);
            w=w.*B(i,:)';
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
            [train_n labtr_n ]=Makedata(train,labtr,p);
            [SVMStruct] = svm_tr(train_n,labtr_n);
            [mis_tr, cpre_tr] = svm_ts(train,labtr,SVMStruct);
            [mis_ts, cpre_ts] = svm_ts(test,labts,SVMStruct);    
            E(i,:)=~(mis_tr');
            e(i)=sum(p.*mis_tr);
            if(e(i)>0.5)
                disp('Error is greater than 0.5 ch');
                disp('Iteration: ');
                disp(i);
                flag=0;
            else flag=1;
            end
            if (flag==1)
            b(i)=e(i)/(1-e(i));
            summ=zeros(1,str(1));
            for k=1:i
                summ=summ+E(k,:)*(e(k)^-1);
            end
            for j=1:str(1)
                if(summ(1,j)~=0)
                    B(i,j)=1/summ(1,j);
                else
                    B(i,j)=1;
                end
            end
            %w=w.*b(i).^(1-mis_tr);
            w=w.*B(i,:)';
            cpre_tr_all(:,:,i)=cpre_tr;
            cpre_ts_all(:,:,i)=cpre_ts;
            mis_tr_all(:,:,i)=mis_tr;
            mis_ts_all(:,:,i)=mis_ts;
            i=i+1;
            end
        end
end
%%%%%%%%%%%   Evaluating
tr_res=zeros(str(1),1);
    for i=1:str(1)
        v=zeros(c,1);
        for t=1:T
            if(mis_tr_all(i,:,t)==0)
            v(cpre_tr_all(i,:,t),1)=v(cpre_tr_all(i,:,t),1)+log10(1/b(t));
            end
        end
        [cn,argmax] = max(v);
        tr_res(i,1) = argmax;
    end
    tr_err = (tr_res ~= labtr);
    trerr = sum(tr_err)/str(1);
    fprintf(1, 'Training error of %s is %f\n',type, trerr);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    ts_res=zeros(sts(1),1);
    for i=1:sts(1)
        v=zeros(c,1);
        for t=1:T
            if(mis_ts_all(i,:,t)==0)
            v(cpre_ts_all(i,:,t),1)=v(cpre_ts_all(i,:,t),1)+log10(1/b(t));
            end
        end
        [cn,argmax] = max(v);
        ts_res(i,1) = argmax;
    end
    ts_err = (ts_res ~= labts);
    tserr = sum(ts_err)/sts(1);
    fprintf(1, 'Testing error of %s is %f\n',type,tserr);
end

