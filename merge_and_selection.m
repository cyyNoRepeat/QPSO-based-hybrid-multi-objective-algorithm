function [f,g]  = merge_and_selection(population,population_value,mutation_population,mutation_population_value,pop_size,nObj)
M = nObj ;
V = size(mutation_population_value,2);
for i = 1 : pop_size
    merge_population(i,:) = population(i,:); 
    merge_population_value(i,:) = population_value(i,:);
end
for i = 1 : pop_size
    merge_population(i+pop_size,:) = mutation_population(i,:);
    merge_population_value(i+pop_size,:) = mutation_population_value(i,:);
end
[value,index] = sort(merge_population_value(:,1));
for i = 1 : length(index)
    sort_merge_population(i,:) =  merge_population(index(i),:);
    sort_merge_population_value(i,:) = merge_population_value(index(i),:);
end
last_value = sort_merge_population_value(pop_size,1);
lnumber = find(sort_merge_population_value(:,1) == last_value,1,'last');
if lnumber > pop_size             
    fnumber = find(sort_merge_population_value(:,1) == last_value,1,'first');
    solution_value = sort_merge_population_value(fnumber:lnumber,:);
    for i  = 1 : lnumber-fnumber+1
        solution_index(i) = fnumber-1+i;
    end
    [sort_index,sort_value] = non_domination_sort_mod(solution_index,solution_value,M);
    need_number = pop_size - fnumber + 1;
    [part_index,part_value] = Determination_solution(sort_index,sort_value,pop_size,need_number,V,"part");
    f(1:pop_size-need_number,:) = sort_merge_population(1:pop_size-need_number,:);
    g(1:pop_size-need_number,:) = sort_merge_population_value(1:pop_size-need_number,:);
    for i = 1 : length(part_index)
        f(pop_size-need_number+i,:) = sort_merge_population(part_index(i),:);
        g(pop_size-need_number+i,:) = sort_merge_population_value(part_index(i),:);
    end
else
    f = sort_merge_population(1:pop_size,:);
    g = sort_merge_population_value(1:pop_size,:);
end


