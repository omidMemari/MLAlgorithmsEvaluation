clc;
load bupa;
load dermatology;
load glass;
load ionosphere;
load pima;
load sonar;
K=6;
c=2;
% Train=bupa(1:172,1:6);
% lab_tr=bupa(1:172,7);
% Test=bupa(173:345,1:6);
% lab_ts=bupa(173:345,7);
% plotss(K,Train, lab_tr,Test, lab_ts,c);

% Train=dermatology(1:179,1:34);
% lab_tr=dermatology(1:179,35);
% Test=dermatology(180:358,1:34);
% lab_ts=dermatology(180:358,35);
% plotss(K,Train, lab_tr,Test, lab_ts,6);

% Train=glass(1:107,1:10);
% lab_tr=glass(1:107,11);
% Test=glass(108:214,1:10);
% lab_ts=glass(108:214,11);
% plotss(K,Train, lab_tr,Test, lab_ts,7);

% Train=ionosphere(1:175,1:34);
% lab_tr=ionosphere(1:175,35);
% Test=ionosphere(176:351,1:34);
% lab_ts=ionosphere(176:351,35);
%  plotss(K,Train, lab_tr,Test, lab_ts,2);

% Train=pima(1:384,1:8);
% lab_tr=pima(1:384,9);
% Test=pima(385:768,1:8);
% lab_ts=pima(385:768,9);
% plotss(K,Train, lab_tr,Test, lab_ts,2);

Train=sonar(1:108,1:60);
lab_tr=sonar(1:108,61);
Test=sonar(109:208,1:60);
lab_ts=sonar(109:208,61);
plotss(K,Train, lab_tr,Test, lab_ts,2);