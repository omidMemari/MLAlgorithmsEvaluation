classdef Classifier < handle
    properties
        center
        radius
        fitness
        ow
        hw
        timeGA
        nnum
        Cnumber
        Tnumber
    end
    
    events
        fitnesscal
    end
    
    methods (Static)
        function assignfitness(CL)
            
            CL.fitness = CL.Cnumber/CL.Tnumber;
            CL.Cnumber=0;
            CL.Tnumber=0;
            
        end
        function fitt(CL)
            % Add a listener for fitnesscal
            addlistener(CL, 'fitnesscal', ...
                @(src, evnt)Classifier.assignfitness(src));
        end
    end
    
    methods
        function CL = Classifier( center,radius,fitness,ow,hw,timeGA,nnum,Cnumber,Tnumber)
            
            CL.center = center;
            CL.radius = radius;
            CL.fitness = fitness;
            CL.ow = ow;
            CL.hw = hw;
            CL.timeGA = timeGA;
            CL.nnum = nnum;
            CL.Tnumber=Tnumber;
            CL.Cnumber=Cnumber;
            
            %             Classifier.fitt(CL);
        end
        
        function [z,y,x,w]=output(CL,x1)
            z=zeros(10,size(x1,2));
            w=zeros(1,size(x1,2));
            for i=1:size(CL,2)
                temp=ones(1,size(x1,2));
                x=[x1;temp];
                y=[tanh((CL(i).hw)'*x);temp];
                z(:,i)=tanh((CL(i).ow)'*y);
                w(i)=CL(i).fitness;
            end
        end
        
        function update(CL,x1,label,eta,p,lambda)
            
            for i=1:size(CL,2)
                [z,y,x]=output(CL(i),x1);
                s=(repmat((1-tanh(y'*CL(i).ow).^2),CL(i).nnum,1).*CL(i).ow(1:CL(i).nnum,:))*(label-z);
                CL(i).hw = CL(i).hw+eta*x*(s'.*(1-tanh(x'*CL(i).hw).^2));
                CL(i).ow = CL(i).ow+eta*y*((label-lambda*p-(1-lambda)*z)'.*(1-tanh(y'*CL(i).ow).^2));
            end
            %             CL.Tnumber=CL.Tnumber;
            %             if CL.Tnumber > 100
            %                 notify(CL,'fitnesscal')
            %             end
            
            
        end
        
    end
    
end