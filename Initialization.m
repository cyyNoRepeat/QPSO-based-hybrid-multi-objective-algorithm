function f = Initialization(pop_size,number_dvar,activity,deadline,num_k)  
duration1=150;
for i = 1 : pop_size
    temp=[];
    for j=1:number_dvar/num_k
        stj(1)=randi([70,duration1]);
        stj(2)=randi([stj(1),deadline]);
        temp=[temp,stj];
    end
    st(i,:)=temp; 
    aa = activity.rate();
    bb = size(aa,2);
    cc = randi(bb,1,number_dvar);
    temp=[];
    for j=1:number_dvar
        temp=[temp,aa(j,cc(j))];
    end
    rate(i,:)=temp;
end
f = [rate,st];
