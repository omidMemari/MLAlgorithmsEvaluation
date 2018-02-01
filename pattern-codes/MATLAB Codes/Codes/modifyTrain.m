clear all
clc
No_features=9;
load Data_cond


train = X_train;
test = X_test;

n = randperm(1500);
train_small = zeros(No_features,500,10);
    for j = 1:500
        train_small(:,j,:) = train(:,n(j),:);
    end

    Train = train(:,:,1)';
    Train_small = train_small(:,:,1)';
    Test = test(:,:,1)';
    for j=2:10
            Train = [Train ; train(:,:,j)'];
            Train_small = [Train_small ; train_small(:,:,j)'];
            Test = [Test ; test(:,:,j)'];
    end

    train_label = zeros(15000,1);
    for i = 1:10
        train_label((i-1)*1500+1:i*1500,1) = i;
    end
    
    train_label_small = zeros(5000,1);
    for i = 1:10
        train_label_small((i-1)*500+1:i*500,1) = i;
    end
    
    test_label = zeros(5000,1);
    for i = 1:10
        for j = ((i-1)*500+1):(i*500)
            test_label(j,1) = i;
        end
    end
    
    
    save Train
    save Train_small
    save Test
    save train_label
    save test_label
    save train_label_small
    save Ada_Boost_Data