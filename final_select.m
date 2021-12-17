function [f,g]  = final_select(population,population_value,final_pop,nObj)
M = nObj ;
V = size(population_value,2);
[value,index] = sort(population_value(:,1));
for i = 1 : length(index)
    sort_population(i,:) =  population(index(i),:);
    sort_population_value(i,:) = population_value(index(i),:);
end
last_value = sort_population_value(final_pop,1);
lnumber = find(sort_population_value(:,1) == last_value,1,'last');
if lnumber > final_pop             
    fnumber = find(sort_population_value(:,1) == last_value,1,'first');
    solution_value = sort_population_value(fnumber:lnumber,:);
    for i  = 1 : lnumber-fnumber+1
        solution_index(i) = fnumber-1+i;
    end
    [sort_index,sort_value] = non_domination_sort_mod(solution_index,solution_value,M);
    need_number = final_pop - fnumber + 1;
    [part_index,part_value] = Determination_solution(sort_index,sort_value,final_pop,need_number,V,"part");
    f(1:final_pop-need_number,:) = sort_population(1:final_pop-need_number,:);
    g(1:final_pop-need_number,:) = sort_population_value(1:final_pop-need_number,:);
    for i = 1 : length(part_index)
        f(final_pop-need_number+i,:) = sort_population(part_index(i),:);
        g(final_pop-need_number+i,:) = sort_population_value(part_index(i),:);
    end
else
    f = sort_population(1:final_pop,:);
    g = sort_population_value(1:final_pop,:);
end


