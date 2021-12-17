function [index,value] = Determination_solution(sort_index,sort_value,External_archive_size,need_number,V,character)
if character == "all"
    number = External_archive_size ; 
else
    number = need_number;
end
max_rank = max(sort_value(:,V + 1));
previous_index = 0;
for i = 1 : max_rank
    current_index = find(sort_value(:, V + 1) == i, 1, 'last' );
    if current_index > number                                 
       remaining = number - previous_index;
       temp_value = sort_value(previous_index + 1 :current_index,: );
       temp_index = sort_index(previous_index + 1 : current_index,:);
       [temp_sort,temp_sort_index] = sort(temp_value(:, V + 2),'descend');
       for j = 1 : remaining
           index(previous_index + j,:) = temp_index(temp_sort_index(j),:);    %’‚÷ª «index
           value(previous_index + j,:) = temp_value(temp_sort_index(j),:);
       end
       return;
    elseif current_index < number
        index(previous_index + 1 : current_index, :) = sort_index(previous_index + 1 : current_index, :);
        value(previous_index + 1 : current_index, :) = sort_value(previous_index + 1 : current_index, :);
    else
        index(previous_index + 1 : current_index, :) = sort_index(previous_index + 1 : current_index, :);
        value(previous_index + 1 : current_index, :) = sort_value(previous_index + 1 : current_index, :);
        return;
    end
    previous_index = current_index;
end


