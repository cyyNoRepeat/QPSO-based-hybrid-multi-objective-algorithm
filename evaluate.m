%Objective Function Evaluation
function [f,g] = evaluate(population,number_dvar,state,activity,resource_available,deadline,initialization,lim,num_k)
[row,col] = size(population);
rate = population(:,1:number_dvar);
all_modes=activity.rate;
all_cost=activity.cost;
all_resource1=activity.resource1;
all_resource2=activity.resource2;
all_resource3=activity.resource3;
st = round(population(:,number_dvar+1:col));
p_state=state(:,1);
ini_ie0=initialization(:,3);
dr_ie0=initialization(:,4);
delta=1.1;
ak=0.8;
bk=0.2;
tpc=200;
pc=0.1;
rsa_nt=resource_available';
rsa_3t=1000000000;
ERL=[100000000,100000000,100000000];
ERLT=[100000000000];
w_n=[0.3,0.3,0.4];
l_j=1;
D_h=5.5;
EC=100000000000;
EWL=10000000000;
EMODEDIS=0;

st_final_out=[];
rrate=[];
parfor i = 1 : row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Calculate the condition of each segment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st_temp=[];
st_final=[];
par_st=st(i,:);
par_constr12=zeros(number_dvar/num_k,1);
par_constr23=zeros(number_dvar/num_k,1);
par_constr3=zeros(number_dvar/num_k,1);
par_r_mit0=zeros(number_dvar/num_k,1);
par_r_mit=zeros(number_dvar/num_k,num_k);
par_r_re=zeros(number_dvar/num_k,num_k);
par_r_ini=zeros(number_dvar/num_k,num_k);
par_r_dr=zeros(number_dvar/num_k,num_k);
par_p_con=zeros(number_dvar/num_k,deadline);
par_r_con=zeros(number_dvar/num_k,deadline);
par_delta_con=zeros(number_dvar/num_k,deadline);

for k=1:number_dvar/num_k
    end_activity=num_k*k;
    start_activity=num_k*k-1;
    st_activity=par_st(start_activity:end_activity);
    st_activity=sort(st_activity);
    st_temp=[st_temp,st_activity];
    par_r_mit0(k)=st_activity(1);
    par_r_mit(k,1)=st_activity(2)-st_activity(1);
    par_r_mit(k,2)=deadline-st_activity(2);
    par_r_re(k,1)=ak*(ini_ie0(k)+dr_ie0(k)*st_activity(1))+bk;
    par_r_ini(k,1)=ini_ie0(k)+dr_ie0(k)*st_activity(1)-par_r_re(k,1);
    par_r_dr(k,1)=dr_ie0(k)*delta;
    par_r_re(k,2)=ak*(par_r_ini(k,1)+par_r_dr(k,1)*par_r_mit(k,1))+bk;
    par_r_ini(k,2)=par_r_ini(k,1)+par_r_dr(k,1)*par_r_mit(k,1)-par_r_re(k,2);
    par_r_dr(k,2)=par_r_dr(k,1)*delta;
    for d=1:deadline
        if d<=st_activity(1)
            par_r_con(k,d) =ini_ie0(k)+dr_ie0(k)*d;
        end
        if d<=st_activity(2) && d>st_activity(1)
            par_r_con(k,d) =par_r_ini(k,1)+par_r_dr(k,1)*(d-st_activity(1));
        end
        if d<=deadline && d>st_activity(2)
            par_r_con(k,d) =par_r_ini(k,2)+par_r_dr(k,2)*(d-st_activity(2));
        end
    end
    par_p_con(k,:)=p_state(deadline*k-(deadline-1):deadline*k);
    par_delta_con(:,:)=abs(par_p_con(:,:)-par_r_con(:,:));
end
st_final=[st_final;st_temp];
st_final_out=[st_final_out;st_final];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Calculate the condition of each segment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mode distribute%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

mode_ijd=zeros(row,number_dvar,deadline);
mmode_id=zeros(row,number_dvar);
mode_id=zeros(number_dvar,1);
par_mode_dis=zeros(row,deadline);
linshi=[];
rrate_i=zeros(1,number_dvar);
for d=1:deadline
    rand_mode=randi(3);
    for j=1:number_dvar
        if d==st_final(j)
            mode_ijd(i,j,d)=rand_mode;
        end
    end
    mmode_id(i,:)=mode_ijd(i,:,d);
    linshi=[linshi;mmode_id(i,:)];
    mode_id=nonzeros(mode_ijd(i,:,d));
    par_mode_dis(i,d)=sum(abs(mode_id-mean(mode_id)));
end
rrate_i(1,:)=nonzeros(linshi)';
rrate=[rrate;rrate_i];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mode distribute%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
            
x_ijd=zeros(row,number_dvar,deadline);
z_id=zeros(row,deadline);
for d=1:deadline
    for j=1:number_dvar
        if st_final(j)==d
            x_ijd(i,j,d)=1;
        end
    end
    z_id(i,d)=max(x_ijd(i,:,d));
end


rs1_ijd=zeros(row,number_dvar,deadline);
rs2_ijd=zeros(row,number_dvar,deadline);
rs3_ijd=zeros(row,number_dvar,deadline);
ms_ijd=zeros(row,number_dvar,deadline);
mc_ijd=zeros(row,number_dvar,deadline);
mt_ijd=zeros(row,number_dvar,deadline);
rs1_ij=zeros(row,number_dvar);
rs2_ij=zeros(row,number_dvar);
rs3_ij=zeros(row,number_dvar);
ms_ij=zeros(row,number_dvar);
mc_ij=zeros(row,number_dvar);

for j=1:number_dvar
    modej=rrate_i(1,j);
    rs1_ij(i,j)=all_resource1(j,modej);
    rs2_ij(i,j)=all_resource2(j,modej);
    rs3_ij(i,j)=all_resource3(j,modej);
    ms_ij(i,j)=all_modes(j,modej);
    mc_ij(i,j)=all_cost(j,modej);
    
    rs1_ijd(i,j,st_final(j))=rs1_ij(i,j);
    rs2_ijd(i,j,st_final(j))=rs2_ij(i,j);
    rs3_ijd(i,j,st_final(j))=rs3_ij(i,j);
    ms_ijd(i,j,st_final(j))=ms_ij(i,j);
    mc_ijd(i,j,st_final(j))=mc_ij(i,j);
    mt_ijd(i,j,st_final(j))=l_j/ms_ijd(i,j,st_final(j));
end



rs1_id=zeros(row,deadline);
rs2_id=zeros(row,deadline);
rs3_id=zeros(row,deadline);
mt_id=zeros(row,deadline);
t_id=zeros(row,deadline);

    
for d=1:deadline
    if length(find(rs1_ijd(:,:,d)~=0))>0
        rs1_id(i,d)=sum(rs1_ijd(i,:,d));
        rs2_id(i,d)=sum(rs2_ijd(i,:,d));
        rs3_id(i,d)=sum(rs3_ijd(i,:,d));
        mt_id(i,d)=sum(mt_ijd(i,:,d));
        t_id(i,d)=z_id(i,d).*d;
    end
end

H(i)=sum(z_id(i,:));
par_SW=nonzeros(t_id(i,:))';
par_wl(i)=sum(abs(par_SW(2:end)-par_SW(1:end-1)-deadline/H(i)));
    
    
rs1p(i)=max(rs1_id(i,:));
rs2p(i)=max(rs2_id(i,:));
rs3p(i)=max(rs3_id(i,:));

rs1t(i)=sum(rs1_id(i,:));
rs2t(i)=sum(rs2_id(i,:));
rs3t(i)=sum(rs3_id(i,:));

Tmc(i)=sum(sum(mc_ijd(i,:,:)));
Ttpc(i)=sum(z_id(i,:))*tpc;
Tpc(i)=sum(sum(par_delta_con(:,:)))*pc;


par_nz_rl1=nonzeros(rs1_id(i,:));
par_nz_rl1_ava=mean(par_nz_rl1);
par_nz_rl1_delta=sum(abs(par_nz_rl1-par_nz_rl1_ava));

par_nz_rl2=nonzeros(rs2_id(i,:));
par_nz_rl2_ava=mean(par_nz_rl2);
par_nz_rl2_delta=sum(abs(par_nz_rl2-par_nz_rl2_ava));

par_nz_rl3=nonzeros(rs3_id(i,:));
par_nz_rl3_ava=mean(par_nz_rl3);
par_nz_rl3_delta=sum(abs(par_nz_rl3-par_nz_rl3_ava));

par_Trl(i)=w_n(1)*par_nz_rl1_delta+w_n(2)*par_nz_rl2_delta+w_n(3)*par_nz_rl3_delta;



constraint=zeros(number_dvar/num_k*deadline+deadline*3+7+deadline,1);
chazhi=zeros(number_dvar/num_k,deadline);
for k=1:number_dvar/num_k
    chazhi(k,:)=par_r_con(k,:)-lim(k);
end
constraint(1:number_dvar/num_k*deadline)=chazhi(:,:);
constraint(number_dvar/num_k*deadline+1:number_dvar/num_k*deadline+deadline)=rs1_id(i,:)-rsa_nt(1,:);
constraint(number_dvar/num_k*deadline+deadline+1:number_dvar/num_k*deadline+deadline*2)=rs2_id(i,:)-rsa_nt(2,:);
constraint(number_dvar/num_k*deadline+deadline*2+1)=rs3t(i)-rsa_3t;
constraint(number_dvar/num_k*deadline+deadline*2+2)=sum(abs(rs1_id(i,2:end)-rs1_id(i,1:end-1)))-ERL(1);
constraint(number_dvar/num_k*deadline+deadline*2+3)=sum(abs(rs2_id(i,2:end)-rs2_id(i,1:end-1)))-ERL(2);
constraint(number_dvar/num_k*deadline+deadline*2+4)=sum(abs(rs3_id(i,2:end)-rs3_id(i,1:end-1)))-ERL(3);
constraint(number_dvar/num_k*deadline+deadline*2+5)=w_n(1)*sum(abs(rs1_id(i,2:end)-rs1_id(i,1:end-1)))+w_n(2)*sum(abs(rs2_id(i,2:end)-rs2_id(i,1:end-1)))+w_n(3)*sum(abs(rs3_id(i,2:end)-rs3_id(i,1:end-1)))-ERLT;
constraint(number_dvar/num_k*deadline+deadline*2+6:number_dvar/num_k*deadline+deadline*3+5)=mt_id(i,:)-D_h;
constraint(number_dvar/num_k*deadline+deadline*3+6)=Tmc(i)+Ttpc(i)-EC;
constraint(number_dvar/num_k*deadline+deadline*3+7)=par_wl(i)-EWL;
constraint(number_dvar/num_k*deadline+deadline*3+8:number_dvar/num_k*deadline+deadline*3+7+deadline)=par_mode_dis(i,:)-EMODEDIS;
    
for c = 1 : number_dvar/num_k*deadline+deadline*3+7+deadline
    if constraint(c) < 0
        constraint(c) = 0;
    end
end
Constraint_Value(i) = sum(constraint)+sum(par_constr12)+sum(par_constr23)+sum(par_constr3);
TotalCost(i)=Tmc(i)+Ttpc(i)+Tpc(i);
end
f = [Constraint_Value',TotalCost',par_Trl',par_wl'];
g=[rrate,st_final_out];


