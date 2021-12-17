function [f,f_value] = update_best(population,population_value,Pbest,Pbest_value,nObj)
[N,V] = size(population_value);
M = nObj;
for i = 1 : N     
    if population_value(i,1) < Pbest_value(i,1)
        Pbest(i,:) = population(i,:);
        Pbest_value(i,:) = population_value(i,:);
    elseif population_value(i,1) == Pbest_value(i,1)
        for j = 1 : M
            dom_less = 0;
            dom_equal = 0;
            dom_more = 0;
            if population_value(i,1+j) < Pbest_value(i,1+j)
                dom_less = dom_less + 1;
            elseif population_value(i,1+j) == Pbest_value(i,1+j)
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_more == 0                                   
            Pbest(i,:) = population(i,:);
            Pbest_value(i,:) = population_value(i,:);
        else
            r1 =rand(1);                                     
            if r1 <= 0.5
                Pbest(i,:) = population(i,:);
                Pbest_value(i,:) = population_value(i,:);
            end
        end
    end
end
f = Pbest;
f_value = Pbest_value;


