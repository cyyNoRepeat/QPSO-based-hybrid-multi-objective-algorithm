function f  = Particle_movement(population,number_dvar,Pbest,Gbest,beta,activity) 
pop_size=size(population,1);
mbest = sum(Pbest)/pop_size;
newpop=[];
for i = 1 : pop_size
    newpop1=zeros(number_dvar,1);
    aa = activity.rate();
    bb = size(aa,2);
    cc = randi(bb,1,number_dvar);
    temp=[];
    for j=1:number_dvar
        temp=[temp,aa(j,cc(j))];
    end
    rate_iteration(i,:)=temp;
    
    w = rand(1);
    pp = w * Pbest(i,:) + (1-w) * Gbest;
    u = rand(1);
    if w <= 0.5
        afa = 1;
    else
        afa = -1;
    end
    newplace = pp + afa * beta * abs(mbest - population(i,:)) * log(1/u);
    feasible = clampdown(newplace,Pbest(i,:),Gbest,population);
    newpop1(1:number_dvar) = rate_iteration(i,:);
    newpop1(number_dvar+1:2*number_dvar) = ceil(feasible(number_dvar+1:2*number_dvar));
    newpop=[newpop;newpop1'];
end
f = newpop;


