function SVM(No_features)
if(No_features==9)
    load Data_cond
else
    load Data_n
end
sigm=4.6;
CCR=zeros(1,length(sigm));
conf = zeros(10);
svmcell={};
cnt=1;
Length=45;
WaitBar = waitbar(0,'Initializing training step...','Name','SVM Method');
for i=1:9
    for ii=i+1:10
        tic;
        svmcell{cnt} = svmtrain([X_train(:,:,i)';X_train(:,:,ii)'],[i*ones(1500,1);ii*ones(1500,1)],'kernel_function','rbf','rbf_sigma',sigm,'method','SMO');
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
            w(:,cnt)=svmclassify(svmcell{cnt},x);
            cnt=cnt+1;
        end
    end
    w=mode(w')';
    for j=1:500
        conf(z,w(j))=conf(z,w(j))+1;
    end
    t=toc;
    Perc=z/Length;
    Trem=(10-z)*t;
    Hrs=floor(Trem/3600);Min=floor((Trem-Hrs*3600)/60);
    waitbar(Perc,WaitBar,['Testing step:    ' sprintf('%0.1f',Perc*100) '%']);
end
confn=conf;
for i=1:10
    confn(i,:)=confn(i,:)/sum(confn(i,:));
end
ccr=trace(conf)/sum(sum(conf));
msgbox(['              CCR = ' num2str(ccr) '      '],'SVM Method');
delete(WaitBar);