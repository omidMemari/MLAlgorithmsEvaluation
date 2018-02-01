function NLCS(NNumber)
clc
%Initialization
if NNumber==50
    load Data.mat
else
    load('Data_cond.mat')
end
figure1=figure;
if NNumber == 50
    X_train = reshape(X_train,50,[],1);
    X_test = reshape(X_test,50,[],1);
    FP.ymin = -1; FP.ymax = 1;
    [X_train, Xs]= mapminmax(X_train,FP);
    X_train = reshape(X_train,50,[],10);
    X_test = mapminmax('apply',X_test,Xs);
    X_test = reshape(X_test,50,[],10);
end

Total=40;

c=10;
d=NNumber;

Ztr=zeros(c,1500,10);
Zte=zeros(c,500,10);
Jtr=zeros(1,Total);
Jte=zeros(1,Total);
N=zeros(1,Total);
NN=zeros(1,Total);

MAX_N_CL=20;

rad(50)=0.001;
rad(9)=0.05;
radius=rad(NNumber);

nhh(50)=15;
nhh(9)=10;
nh=nhh(NNumber);



CL(1) = Classifier( ones(d,1),radius,1,rand(nh+1,c)-0.5,rand(d+1,nh)-0.5,0,nh,0,1);

centerbank=CL(1).center;
flag1=0;
CLN=0;

R=0;
aa=0.95;
lambda=0.5;
xx=zeros(d,1);
counter=1;
for n=1:Total
    eta=max(0.01,10^-(n/40+1+.5));
    aa=aa+0.0005;
    
    
    
    qq=randperm(15000);
    
    for q=qq(1:15000)
        
        t=ones(c,1)*(-aa);
        k=floor((q-1)/1500)+1;
        index=q-floor((q-1)/1500)*1500;
        t(k)=aa;
        
        r=size(centerbank,2);
        
        x=X_train(:,index,k);
        
        dis0=min(abs(centerbank-repmat(x,1,r)));
        [dis,dindex]=min(dis0);
        if dis <= radius
            
            NNindex=find(dis0 <= radius);
            
            [z,~,~,w]=output(CL(NNindex),x);
            
            p=z*w'/sum(w);
            
            update(CL(NNindex),x,t,eta,p,lambda)
            
        else
            if CLN < MAX_N_CL
                p=zeros(10,1);
                CLN=CLN+1;
                CL(CLN) = Classifier( x,radius,1,CL(dindex).ow,CL(dindex).hw,0,nh,0,1);
                update(CL(CLN),x,t,eta,p,0)
                if CLN==1
                    centerbank=CL(CLN).center;
                else
                    centerbank=[centerbank CL(CLN).center];
                end
                
            else
                
                for m=1:CLN
                    a(m)=CL(m).fitness;
                end
                
                [~,b]=min(a);
                
                CL(b).timeGA=CL(b).timeGA+1;
                
                if CL(b).timeGA > 10
                    gamma=0.001;
                    CL(b).center=(1-gamma)*CL(b).center+gamma*xx/counter;
                    centerbank(:,b)=CL(b).center;
                    
                    for kk=1:size(CL,2)
                        CL(kk).timeGA = 1;
                    end
                    
                end
                
            end
            
        end
        
    end
    
    
    r=size(centerbank,2);
    R=R+1;
    counter=0;
    xx=zeros(d,1);
    
    
    for q=qq(1:5000)
        
        t=ones(c,1)*(-aa);
        k=floor((q-1)/1500)+1;
        index=q-floor((q-1)/1500)*1500;
        t(k)=aa;
        
        x=X_train(:,index,k);
        
        dis0=min(abs(centerbank-repmat(x,1,r)));
        [dis,dindex]=min(dis0);
        
        if (dis > radius)
            [~,dis2]=sort(min(abs(centerbank-repmat(x,1,r))));
            [z,~,~,W]=output(CL(dis2(1:round(CLN/10+1))),x);
            Z=z*W';
        else
            NNindex=find(dis0 <= radius);
            [z,~,~,W]=output(CL(NNindex),x);
            Z=z*W';
        end
        
        [~,FF]=max(Z);
        
        if ~(FF==k)
            xx=x+xx;
            counter=counter+1;
        end
        
        
        N(R)=N(R)+(FF==k);
        
        if (dis <= radius)
            for i=NNindex
                CL(i).Tnumber=CL(i).Tnumber+1;
                CL(i).Cnumber=CL(i).Cnumber+(FF==k);
            end
        end
        
    end
    
    for m=1:CLN
        CL(m).fitness=CL(m).Cnumber/CL(m).Tnumber*100;
    end
    
    for q=1:5000
        
        t=ones(c,1)*(-aa);
        k=floor((q-1)/500)+1;
        index=q-floor((q-1)/500)*500;
        t(k)=aa;
        
        x=X_test(:,index,k);
        
        dis0=min(abs(centerbank-repmat(x,1,r)));
        [dis,dindex]=min(dis0);
        
        if (dis > radius)
            [~,dis2]=sort(min(abs(centerbank-repmat(x,1,r))));
            [z,~,~,W]=output(CL(dis2(1:round(CLN/10+1))),x);
            Z=z*W';
        else
            NNindex=find(dis0 <= radius);
            [z,~,~,W]=output(CL(NNindex),x);
            Z=z*W';
        end
        
        [~,FF]=max(Z);
        
        NN(R)=NN(R)+(FF==k);
    end
    
    flag1=1;
    
    for m=1:CLN
        a(m)=CL(m).fitness;
        CL(m).Cnumber=1;
        CL(m).Tnumber=1;
    end
    
    ccr_tr=smooth(N(1:R)/50)';
    ccr_ts=smooth(NN(1:R)/50)';
    subplot2 = subplot(1,1,1,'Parent',figure1,'FontWeight','bold','FontSize',10);
    box(subplot2,'on');
    plot(1:R,ccr_tr(1,1:R),'b','MarkerSize',4.5,'Marker','square','LineWidth',2,'DisplayName','Train');
    hold on
    grid
    plot(1:R,ccr_ts(1,1:R),'r','MarkerSize',4.5,'Marker','o','LineWidth',2,'DisplayName','Test');
    xlabel('No. of Epochs','FontWeight','bold','FontSize',11);
    ylabel('CCR','FontWeight','bold','FontSize',11);
    legend1 = legend(subplot2,'show');
    set(legend1,'Location','Best','FontSize',8);
    drawnow
    hold off 
end



