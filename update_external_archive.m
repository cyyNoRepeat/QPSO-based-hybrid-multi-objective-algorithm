function [particle,particle_value,GridIndex,GridSubIndex] = update_external_archive(mutation_population,mutation_population_value,pop_size,External_archive_size,elite,elite_value,nGrid, alpha,gamma,nObj)
merge_population = mutation_population;
merge_population_value = mutation_population_value;
V = size(mutation_population_value,2);
M = nObj;
N = size(elite,1);
for i = 1 : N
    merge_population(i+pop_size,:) = elite(i,:);
    merge_population_value(i+pop_size,:) = elite_value(i,:);
end
[value,index] = sort(merge_population_value(:,1));   
for i = 1 : length(index)
    sort_merge_population_value(i,:) = merge_population_value(index(i),:);
    sort_merge_population(i,:) = merge_population(index(i),:);
end
first_value = sort_merge_population_value(1,V-M); 
number = find(sort_merge_population_value(:,V-M)==first_value,1,'last');  
for i = 1 : number
    solution_value(i,:) = sort_merge_population_value(i,:);
    solution_index(i) = i;
end
[sort_index,sort_value] = non_domination_sort_mod(solution_index,solution_value,M);
sort_number = find(sort_value(:,V+1) == 1,1,'last');  

for i=1:sort_number
    rep(i,:)=sort_merge_population(sort_index(i),:);
    rep_value(i,:)=sort_merge_population_value(sort_index(i),:);
end
% Update Grid
Grid = CreateGrid(rep,rep_value, nGrid, alpha);

% Update Grid Indices
for i = 1:size(rep,1)
    [particle(i,:),particle_value(i,:),GridIndex(i),GridSubIndex(i,:)] = FindGridIndex(rep(i,:),rep_value(i,:), Grid);
end

if sort_number > External_archive_size  
    Extra = sort_number-External_archive_size;
    for e = 1:Extra
        [particle,particle_value,GridIndex,GridSubIndex] = DeleteOneRepMemebr(particle,particle_value,GridIndex,GridSubIndex, gamma);
    end    
else
    particle=particle;
    particle_value=particle_value;
    GridIndex=GridIndex;
    GridSubIndex=GridSubIndex;
end


