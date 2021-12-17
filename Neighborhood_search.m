function f  = Neighborhood_search(new_population,elite,pop_size,deadline,number_dvar,Pbest,Gbest,state,activity,resource_available,initialization,lim,num_k,nObj)
M = nObj;
N = size(elite,1);
% Select an individual at random
elite_rand_number = randi(N);
x1.mode = elite(elite_rand_number,1:number_dvar);
x1.st=elite(elite_rand_number,number_dvar+1:2*number_dvar);
randj=randi(number_dvar/num_k-1);
stj=x1.st((randj-1)*num_k+1:(randj-1)*num_k+num_k);
stj1=x1.st(randj*num_k+1:randj*num_k+num_k);
temp_st=[x1.st(1:(randj-1)*num_k),stj1,stj,x1.st((randj+1)*num_k+1:end)];
temp_mode=[x1.mode(1:(randj-1)*num_k),stj1,stj,x1.mode((randj+1)*num_k+1:end)];
% Create a new individual using x1
x2.st=temp_st;
x2.mode=temp_mode;
x2 = clampdown([x2.mode,x2.st],Pbest,Gbest,new_population);

population_rand_number = randi(pop_size);
x3 = new_population(population_rand_number,:);
x2_value = evaluate(x2,number_dvar,state,activity,resource_available,deadline,initialization,lim,num_k);
x3_value = evaluate(x3,number_dvar,state,activity,resource_available,deadline,initialization,lim,num_k);     
% Choose the better
if x2_value(1) < x3_value(1)         
    new_population(population_rand_number,:) = x2;
elseif x2_value(1) == x3_value(1)    
    dom_less = 0;
    dom_equal = 0;
    dom_more = 0;
    for i = 1 : M
        if  x2_value(1+i) < x3_value(1+i)
            dom_less = dom_less + 1 ;
        elseif x2_value(1+i) == x3_value(1+i)
            dom_equal =dom_equal + 1;
        else
            dom_more = dom_more + 1;
        end
    end
    if  dom_more == 0               
        new_population(population_rand_number,:) = x2;
    else
        probability = rand(1);
        if probability <= 0.5
            new_population(population_rand_number,:) = x2;
        end
    end
end
f = new_population;


