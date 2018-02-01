function [ output_args ] = plotss(K,Train, lab_tr,Test, lab_ts,c)
clc;
load bupa;
clear trerr;
clear tserr;
for i=1:K
    [trerr(i), tserr(i)] = adab(i, Train, lab_tr,Test, lab_ts, c,'naive');
end
plot(1:K,trerr,'--go');
hold on;
plot(1:K,tserr,':bs');

for i=1:K
    [trerr(i), tserr(i)] = adab_ch(i, Train, lab_tr,Test, lab_ts, c,'naive');
end
plot(1:K,trerr,'--mo');
hold on;
plot(1:K,tserr,':ks');
hold off;
title 'naive bayes';
legend 'AdaBoost Tr' 'AdaBoost Ts' 'Proposed Tr' 'Proposed Ts'
xlabel 'Number of Iterations'
ylabel 'Error'
%%%%%%%%%%
for i=1:K
    [trerr(i), tserr(i)] = adab(i, Train, lab_tr,Test, lab_ts, c,'knn');
end
figure(2);
plot(1:K,trerr,'--go');
hold on;
plot(1:K,tserr,':bs');
for i=1:K
    [trerr(i), tserr(i)] = adab_ch(i, Train, lab_tr,Test, lab_ts, c,'knn');
end
plot(1:K,trerr,'--mo');
hold on;
plot(1:K,tserr,':ks');
title 'knn';
legend 'AdaBoost Tr' 'AdaBoost Ts' 'Proposed Tr' 'Proposed Ts'
xlabel 'Number of Iterations'
ylabel 'Error'
%%%%%%%%%%%%%%
for i=1:K
    [trerr(i), tserr(i)] = adab(i, Train, lab_tr,Test, lab_ts, c,'svm');
end
figure(3);
plot(1:K,trerr,'--go');
hold on;
plot(1:K,tserr,':bs');
for i=1:K
    [trerr(i), tserr(i)] = adab_ch(i, Train, lab_tr,Test, lab_ts, c,'svm');
end
plot(1:K,trerr,'--mo');
hold on;
plot(1:K,tserr,':ks');
title 'svm';
legend 'AdaBoost Tr' 'AdaBoost Ts' 'Proposed Tr' 'Proposed Ts'
xlabel 'Number of Iterations'
ylabel 'Error'
