function AdaBoost
clc
load Ada_Boost_Data
load No_features
if(No_features==9)
    plw=msgbox(['Please wait...']);
    [trerr, tserr] = adab(5,Train_small,train_label_small,Test,test_label,10,'knn');
else
    plw=msgbox(['Please wait...']);
    [trerr, tserr] = adab(5,Train,train_label,Test,test_label,10,'naive');
end
delete(plw);
ctr = 1-trerr(end);
ctr = round(ctr*1000)/1000;
cts = 1-tserr(end);
cts = round(cts*1000)/1000;
msgbox(['CCR_train = ' num2str(100*ctr) '%,  CCR_test = ' num2str(100*cts) '%.']);