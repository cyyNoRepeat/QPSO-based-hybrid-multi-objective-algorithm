% The hybrid MOQPSO in the article: 
% Yanyan Chang,Rengkui Liu, Yuanjie Tang. Segment-Condition-Based Railway Track Maintenance Schedule Optimization
clc;
clear;
close all;
tic
% Parameter
deadline = 365;
no_mode=3;       % Construction mode of each maintenance activity
num_k=2;         % Maintenance times of each equipment in the scheduling cycle
mode_ms= xlsread('anaTimeND_mid_construction.xlsx',1,'A2:G1801');  % The rate in each mode
mode_mc= xlsread('anaTimeND_mid_construction.xlsx',2,'A2:G1801');  % The cost in each mode
mode_mr= xlsread('anaTimeND_mid_construction.xlsx',3,'A2:I1801');  % The resource usage in each mode
mode_m = xlsread('anaTimeND_mid_construction.xlsx',4,'A2:F1801');  
ini_data= xlsread('anaTimeND_mid_data.xlsx',3,'A2:G301');          % The condition and deterioration rate of each segment
resource_available=xlsread('anaTimeND_mid_constant.xlsx',1,'A1:C365');
size_ms=size(mode_ms,1);
size_mc=size(mode_mc,1);
size_mr=size(mode_mr,1);
size_m=size(mode_m,1);
lim=ini_data(:,7);       % Maintenance threshold of each segment
segment_number = size(ini_data,1);
number_dvar = segment_number * num_k;    % Number of decision variables

size_unique_mode_ms=size(unique(mode_ms(:,7)),1);
size_unique_mode_mc=size(unique(mode_mc(:,7)),1);
size_unique_mode_mr=size(unique(mode_mr(:,9)),1);
size_unique_mode_m=size(unique(mode_m(:,6)),1);
rate=mode_ms(:,5);
cost=mode_mc(:,5);
resource1=mode_mr(:,5);
resource2=mode_mr(:,6);
resource3=mode_mr(:,7);
id_ms=mode_ms(:,7);
id_mc=mode_mc(:,7);
id_mr=mode_mr(:,9);

temp_rate=[];
temp_id=[];
for i=1:size_unique_mode_ms
    rate_i=rate(i==id_ms)';
    id_i=i;
    temp_rate=[temp_rate;rate_i];
    temp_id=[temp_id;i];
end
activity.rate=temp_rate;

temp_cost=[];
for i=1:size_unique_mode_mc
    cost_i=cost(i==id_mc)';
    temp_cost=[temp_cost;cost_i];
end
activity.cost=temp_cost;

temp_resource1=[];
for i=1:size_unique_mode_mr
    resource1_i=resource1(i==id_mr)';
    temp_resource1=[temp_resource1;resource1_i];
end
activity.resource1=temp_resource1;

temp_resource2=[];
for i=1:size_unique_mode_mr
    resource2_i=resource2(i==id_mr)';
    temp_resource2=[temp_resource2;resource2_i];
end
activity.resource2=temp_resource2;

temp_resource3=[];
for i=1:size_unique_mode_mr
    resource3_i=resource3(i==id_mr)';
    temp_resource3=[temp_resource3;resource3_i];
end
activity.resource3=temp_resource3;
activity.id=temp_id;


% Algorithm parameters
nObj=3;
pop_size = 92;
External_archive_size = 92;
iteration = 200;
pMutate=0.4;
k=2;
nGrid = 8;            % Number of Grids per Dimension 
alpha = 0.1;          % Inflation Rate
beta = 2;             % Leader Selection Pressure
gamma = 2;            % Deletion Selection Pressure
pfq = 80;             % Avoid that the population is divided into one cluster
final_pop = 40;

state = condition_calculation();
state=nonzeros(state);
%% Initialize population, external_archive, Pbest and Gbest
population = Initialization(pop_size,number_dvar,activity,deadline,num_k); 
[population_value,evaluate_population] = evaluate(population,number_dvar,state,activity,resource_available,deadline,ini_data,lim,num_k);
[elite,elite_value] = Initialization_external_archive(population,External_archive_size,population_value,nObj);
[Pbest,Gbest,Pbest_value,Gbest_value] = Initialization_best(population,population_value,elite,elite_value);         
A=NaN(iteration,External_archive_size,nObj);

%% Mian Loop
for i = 1 : iteration
    beta_p = 1 - (1-0.5)*i/iteration;
    if k>1
        data=population_value(:,2:4)';
        [res, record,final_index] = FunK_meanPolyD(data,k);
        pop1=population(final_index(1,1:record(1)),:);
        pop2=population(final_index(2,1:record(2)),:);
    else
        pop1=population(1:pfq,:);
        pop2=population(pfq+1:pop_size,:);
    end
    %% update particle
    %pop1 Particle_movement
    pop1 = Particle_movement(pop1,number_dvar,Pbest,Gbest,beta_p,activity);
    
    %pop2 Crossover
    for j=1:size(pop2,1)
        i1 = randi([1 size(pop2,1)]);
        p1 = pop2(i1,:);
        i2 = randi([1 size(pop2,1)]);
        p2 = pop2(i2,:);
        [pop2(i1,:), pop2(i2,:)] = Crossover(p1, p2);
    end

    %merge pop
    new_population=[pop1;pop2];
    
    %% Neighborhood_search
    search_population = Neighborhood_search(new_population,elite,pop_size,deadline,number_dvar,Pbest,Gbest,state,activity,resource_available,ini_data,lim,num_k,nObj);

    %% chaotic_mutation
    mutation_population = chaotic_mutation(search_population,pop_size,deadline,number_dvar,state,activity,no_mode,resource_available,ini_data,lim,num_k);

    %% elite selection
    %evaluate CV and obj
    [mutation_population_value,evaluate_population] = evaluate(mutation_population,number_dvar,state,activity,resource_available,deadline,ini_data,lim,num_k);

    % CV,obj(Pareto),grid----->update_external_archive
    [elite,elite_value,GridIndex,GridSubIndex] = update_external_archive(evaluate_population,mutation_population_value,pop_size,External_archive_size,elite,elite_value,nGrid, alpha,gamma,nObj);
    [Gbest,Gbest_value] = SelectLeader(elite,elite_value,GridIndex,beta);
    %% merge_and_selection
    [population,population_value] = merge_and_selection(population,population_value,evaluate_population,mutation_population_value,pop_size,nObj);

    %% update_best
    [Pbest,Pbest_value] = update_best(population,population_value,Pbest,Pbest_value,nObj);
    
    %% output
    formatSpec ='Number of iterations£º%d'; 
    display (sprintf(formatSpec,i));
    [row,col]=size(elite_value);
    if min(elite_value(1,:))==0
        A(i,1:row,:)=elite_value(:,2:4);
    end
end
toc

%% select the final elite
if size(elite_value,1) > final_pop
    [elite, elite_value] = final_select(elite,elite_value,final_pop,nObj);
end

%% figure
temp_elite_value = unique(elite_value,'rows');
f = elite;
g = temp_elite_value;

figure(1)
plot(temp_elite_value(:,3),temp_elite_value(:,2),'*');
title('Resource leveling & Cost trade-off Figure');
xlabel('Resource leveling');
ylabel('Cost');
box off 

figure(2)
plot(temp_elite_value(:,3),temp_elite_value(:,4),'*');
title('Resource leveling & Window leveling trade-off Figure');
xlabel('Resource leveling');
ylabel('Window leveling');
box off

figure(3)
plot(temp_elite_value(:,2),temp_elite_value(:,4),'*');
title('Cost & Window leveling trade-off Figure');
xlabel('Cost');
ylabel('Window leveling');
box off

figure(4)
N = size(temp_elite_value,1);
a = temp_elite_value(:,2)';
b = temp_elite_value(:,3)';
c = temp_elite_value(:,4)';
Z =[];
for i = 1 : N
    Z = [Z;c];
end
surf(a,b,Z);
title('Pareto Front');
shading interp;
xlabel('Cost');
ylabel('Resource leveling');
zlabel('Window leveling');
elite_value1 =evaluate(elite,number_dvar,state,activity,resource_available,deadline,ini_data);
mutation_population_value = evaluate(mutation_population,number_dvar,state,activity,resource_available,deadline,ini_data);
c = a;

