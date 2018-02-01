function LS_SVM(No_features)
if(No_features==9)
    load Data_cond
else
    load Data_n
end
Grp=[132*ones(1500,1);133*ones(9*1500,1)];
type = 'classification';
L_fold = 2;
conf_train = zeros(10);
conf_test = zeros(10);
model={};
cnt=1;
gam=6;
sig2=12;
Length=45;
WaitBar = waitbar(0,'Initializing training step...','Name','LS-SVM Method');
for i=1:9
    for ii=i+1:10
        tic;
        model_t=trainlssvm({[X_train(:,:,i)';X_train(:,:,ii)'],[i*ones(1500,1);ii*ones(1500,1)],type,gam,sig2,'RBF_kernel'});
        model{cnt} = trainlssvm(model_t);
        t=toc;
        Perc=cnt/Length;
        Trem=(45-cnt)*t;
        Hrs=floor(Trem/3600);Min=floor((Trem-Hrs*3600)/60);
        waitbar(Perc,WaitBar,['Training step:    ' sprintf('%0.1f',Perc*100) '%']);
        cnt=cnt+1;
    end
end
Length=10;
waitbar(0,WaitBar,'Initializing testing step...');
for z=1:10
    x=X_test(:,:,z)';
    w=zeros(500,45);
    cnt=1;
    tic;
    for i=1:9
        for ii=i+1:10
            w(:,cnt)=simlssvm(model{cnt},x);
            cnt=cnt+1;
        end
    end
    w=mode(w')';
    for j=1:500
        conf_test(z,w(j))=conf_test(z,w(j))+1;
    end
    t=toc;
    Perc=z/Length;
    Trem=(10-z)*t;
    Hrs=floor(Trem/3600);Min=floor((Trem-Hrs*3600)/60);
    waitbar(Perc,WaitBar,['Testing step:    ' sprintf('%0.1f',Perc*100) '%']);
end
confn_test=conf_test;
for i=1:10
    confn_test(i,:)=confn_test(i,:)/sum(confn_test(i,:));
end
ccr_test=trace(conf_test)/sum(sum(conf_test));
msgbox(['              CCR = ' num2str(ccr_test) '      '],'SVM Method');
delete(WaitBar);
save cnnnnn confn_test