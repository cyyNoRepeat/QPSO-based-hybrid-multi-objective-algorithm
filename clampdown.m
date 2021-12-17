function f = clampdown(t,Pbest,Gbest,population)
pop_size=size(population,1); 
col = size(t,2);
deadline = 365;
resource = t(1:col/2);
time = t(col/2+1:col);
for i = 1 : col/2
    if time(i) < 0 || time(i) > deadline
        c = round(rand(1)*pop_size);
        while c == 0
            c = round(rand(1)*pop_size);
        end
        d = round(rand(1)*pop_size);
        while d == 0
            d = round(rand(1)*pop_size);
        end
        Ti = population(c,col/2+1:col);
        Tj = population(d,col/2+1:col);
        time(i) = (Pbest(i+col/2) + Gbest(i+col/2) + Ti(i) + Tj(i))/4;        
    end
    if time(i)==0||time(i)>deadline
        time(i)=randi(deadline);
    end
end
f = [resource,time];


