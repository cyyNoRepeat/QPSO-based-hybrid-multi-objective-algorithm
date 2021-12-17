function f = condition_calculation
clc;
clear;
close all;
tic

num_s=300;
num_e=1;
num_d=365;

data= xlsread('TQI.xlsx',6,'A2:C301');
for s=1:num_s
    ini(s)=data(s,3);
    dr(s)=data(s,2);
    for d=1:150
        con(s,d)=ini(s)+dr(s)*d;
    end
    for d=151
        ini(s)=0.2*(ini(s)+dr(s)*d)-0.2;
        dr(s)=data(s,2)*1.1;
        con(s,d)=ini(s)+dr(s)*(d-150);
    end
    for d=152:270
        con(s,d)=ini(s)+dr(s)*(d-151);
    end
    for d=271
        ini(s)=0.2*(ini(s)+dr(s)*d)-0.2;
        dr(s)=data(s,2)*1.1*1.1;
        con(s,d)=ini(s)+dr(s)*(d-270);
    end
    for d=272:365
        con(s,d)=ini(s)+dr(s)*(d-271);
    end
    lim(s)=con(s,150);
end
f=con';
end