function [particle,particle_value,GridIndex,GridSubIndex] = FindGridIndex(particle,particle_value, Grid)

    temp_particle_value=particle_value(2:4);

    nObj = size(temp_particle_value,2);

    nGrid = numel(Grid(1).LB);

    GridSubIndex = zeros(1, nObj);

    for j = 1:nObj

        GridSubIndex(j) = ...
            find(temp_particle_value(j)<Grid(j).UB, 1, 'first');

    end

    GridIndex = (GridSubIndex(1)-1)*nGrid^2+(GridSubIndex(2)-1)*nGrid+GridSubIndex(3);
    
end