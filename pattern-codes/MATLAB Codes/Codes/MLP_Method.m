function MLP_Method(no_f)
clc
if(no_f==9)
    load Data_cond
else
    load Data_n
end
C=10;
Iter=80;
M=50;
et=0.005; 
J=zeros(2,Iter);
figure1=figure;
hold on
W=0.02*(rand(size(X_train,1)+1,M)-0.5);
U=0.02*(rand(M+1,C)-0.5);
ok=0;
for ep=1:Iter
    clf
    wh_c=randperm(C);
    wh_s=randperm(1500);
    for s=wh_s
        for c=wh_c
            t=-ones(C,1);
            t(c)=t(c)*-.95;
            x=X_train(:,s,c);
            x=[1;x];
            net1=W'*x;
            y=tanh(net1);
            y=[1;y];
            net2=U'*y;
            z=tanh(net2);
            e=(t-z);
            delt=e.*(1-(tanh(net2)).^2);
            dU=et*delt*y';
            dW=et*x*((1-(tanh(net1)).^2).*sum( U(1:M,:)'.*repmat(delt,1,M) )')';
            W=W+dW;
            U=U+dU';
        end
    end
    ctrain=zeros(10);
    for c=1:10
        t=-ones(10,1);
        t(c)=t(c)*-.9;
        t=repmat(t,1,1500);
        x=[ones(1,1500);X_train(:,:,c)];
        z=U'*[ones(1,1500);tanh(W'*x)];
        J(1,ep)=J(1,ep)+sum(sum((t-tanh(z)).^2));
        [v,ind]=max(z);
        for i=1:1500
            ctrain(c,ind(i))=ctrain(c,ind(i))+1;
        end
    end
    Jplot_train=smooth(J(1,1:ep))';
    subplot1 = subplot(1,2,1,'Parent',figure1,'FontWeight','bold','FontSize',10);
    box(subplot1,'on');
    hold(subplot1,'all');
    plot(1:ep,Jplot_train(1,1:ep)/15000,'b','MarkerSize',4.5,'Marker','square','LineWidth',2,'DisplayName','Train');
%     drawnow
    hold on
    ctest=zeros(10);
    for c=1:10
        t=-ones(10,1);
        t(c)=t(c)*-.8;
        t=repmat(t,1,500);
        x=[ones(1,500);X_test(:,:,c)];
        z=U'*[ones(1,500);tanh(W'*x)];
        J(2,ep)=J(2,ep)+sum(sum((t-tanh(z)).^2));
        [v,ind]=max(z);
        for i=1:500
            ctest(c,ind(i))=ctest(c,ind(i))+1;
        end
    end
    Jplot_test=smooth(J(2,1:ep))';
    plot(1:ep,Jplot_test(1,1:ep)/5000,'r','MarkerSize',4.5,'Marker','o','LineWidth',2,'DisplayName','Test');
    xlabel('No. of Epochs','FontWeight','bold','FontSize',11);
    ylabel('J','FontWeight','bold','FontSize',11);
    grid
%     drawnow
    hold on
    ccrtrain(1,ep)=trace(ctrain)/15000;
    ccrtest(1,ep)=trace(ctest)/5000;
    ccr_tr=smooth(ccrtrain)';
    ccr_ts=smooth(ccrtest)';
    subplot2 = subplot(1,2,2,'Parent',figure1,'FontWeight','bold','FontSize',10);
    box(subplot2,'on');
    hold(subplot2,'all');
    plot(1:ep,ccr_tr(1,1:ep),'b','MarkerSize',4.5,'Marker','square','LineWidth',2,'DisplayName','Train');
%     drawnow
    hold on
    plot(1:ep,ccr_ts(1,1:ep),'r','MarkerSize',4.5,'Marker','o','LineWidth',2,'DisplayName','Test');
    xlabel('No. of Epochs','FontWeight','bold','FontSize',11);
    ylabel('CCR','FontWeight','bold','FontSize',11);
    legend1 = legend(subplot2,'show');
    set(legend1,...
        'Location','Best','FontSize',8);
    legend2 = legend(subplot1,'show');
    set(legend2,...
        'Location','Best','FontSize',8);
    grid
    drawnow
    hold on
end