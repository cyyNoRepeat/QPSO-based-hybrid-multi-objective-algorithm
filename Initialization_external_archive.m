function [f,g] = Initialization_external_archive(population,External_archive_size,population_value,nObj)
V = size(population_value,2);
[temp,order] = sort(population_value(:,V-nObj));
for i = 1 : length(order)
    sort_population(i,:) = population(order(i),:);
    sort_population_value(i,:) = population_value(order(i),:);
end
first_value = sort_population_value(1,1);
number = find(sort_population_value(:,V-nObj)==first_value,1,'last');
for i = 1 : number
    solution(i,:) = sort_population(i,:);
    solution_value(i,:) = sort_population_value(i,:);
    solution_index(i) = i;
end
[sort_index,sort_value] = non_domination_sort_mod(solution_index,solution_value,nObj);
sort_number = find(sort_value(:,V+1) == 1,1,'last');                        
if sort_number > External_archive_size
    [index,value] = Determination_solution(sort_index,sort_value,External_archive_size,need_number,V,"all");
    for i = 1 : length(index)
        f(i,:) = sort_population(index(i),:);
        g(i,:) = sort_population_value(index(i),:);
    end
else
    for i = 1 : sort_number
        f(i,:) = sort_population(sort_index(i),:);
        g(i,:) = sort_population_value(sort_index(i),:);
    end
end


