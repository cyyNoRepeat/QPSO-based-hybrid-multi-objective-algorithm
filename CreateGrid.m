function Grid = CreateGrid(pop,pop_value,nGrid, alpha)
for i=1:size(pop_value,1)
    c(:,i) = pop_value(i,2:4)';
    
    cmin(:,i) = min(c(:,i), [], 2);
    cmax(:,i) = max(c(:,i), [], 2);
    
    dc(:,i) = cmax(:,i)-cmin(:,i);
    cmin(:,i) = cmin(:,i)-alpha*dc(:,i);
    cmax(:,i) = cmax(:,i)+alpha*dc(:,i);
    
    nObj = size(c(:,i), 1);
    
    for j = 1:nObj
        
        cj(i,:) = linspace(cmin(j,i), cmax(j,i), nGrid+1);
        
        Grid(i,j).LB = [-inf cj(i,:)];
        Grid(i,j).UB = [cj(i,:) +inf];
        
    end
end
end