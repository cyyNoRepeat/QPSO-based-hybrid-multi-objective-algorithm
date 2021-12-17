function [f,g] = non_domination_sort_mod(index,value,M)
a = size(index,1);
if a == 1
    index = index';
end
[N,V] = size(value);
front = 1;
F(front).f =[];
individual = []; 
x = value;    
for i = 1 : N
    individual(i).n = 0;  
    individual(i).p = []; 
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M
            if x(i,1+k) < x(j,1+k)
                dom_less = dom_less + 1;
            elseif x(i,1+k) == x(j,1+k)
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M
            individual(i).n = individual(i).n + 1;   
        elseif dom_more == 0 && dom_equal ~= M
            individual(i).p = [individual(i).p j];
        end
    end
    if individual(i).n == 0
        x(i, V + 1) = 1;
        F(front).f = [F(front).f i];
    end
end
while ~isempty(F(front).f)
    Q = [];
    for i = 1 : length(F(front).f)
         if ~isempty(individual(F(front).f(i)).p)
             for j = 1 :length(individual(F(front).f(i)).p)
                 individual(individual(F(front).f(i)).p(j)).n = individual(individual(F(front).f(i)).p(j)).n - 1;
                 if individual(individual(F(front).f(i)).p(j)).n == 0
                     x(individual(F(front).f(i)).p(j),  V + 1) = front + 1;
                     Q = [Q individual(F(front).f(i)).p(j)];
                 end
             end
         end
    end
    front = front + 1;
    F(front).f = Q;
end         
[temp,index_of_fronts] = sort(x(:,V+1));  
for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);       
    sorted_based_on_index(i,:) = index(index_of_fronts(i),:);
end
sorted_based_on_front_nor = Normalization(sorted_based_on_front,M);  
current_index = 0;
for front = 1 : (length(F)-1)
    objective = [];
    distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)
        y(i,:) = sorted_based_on_front_nor(current_index + i,:);    
    end
    current_index = current_index + i;
    sorted_based_on_objective = [];
    for i = 1 : M
        [sorted_based_on_objective, index_of_objectives] = sort(y(:, 1 + i)); 
         sorted_based_on_objective = [];
         for j = 1 : length(index_of_objectives)
             sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
         end
         f_max = sorted_based_on_objective(length(index_of_objectives),1 + i);
         f_min = sorted_based_on_objective(1,1 + i);
         y(index_of_objectives(length(index_of_objectives)),V+1+i) = Inf;
         y(index_of_objectives(1),V+1+i) = Inf;
         for j = 2 : length(index_of_objectives)-1
             next_obj = sorted_based_on_objective(j + 1,1 + i);        
             previous_obj = sorted_based_on_objective(j - 1,1 + i);
             if (f_max - f_min == 0)
                  y(index_of_objectives(j),V + 1 + i) = Inf;           
             else
                  y(index_of_objectives(j),V + 1 + i) = (next_obj - previous_obj)/(f_max - f_min);
             end
         end
    end
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:, V + 1 + i);
    end
     y(:, V + 2) = distance; 
     y = y(:, 1 : V + 2);
     z(previous_index:current_index,:) = y;             
end
f = sorted_based_on_index;
g = [sorted_based_on_front,z(:,V+2)];     