function [ res, record,final_index] = FunK_meanPolyD(data,k )
j = 1;

[h w] = size(data);
cnt = w;
cntOfDimension = h;

seed = zeros(cntOfDimension,k);
oldSeed = zeros(cntOfDimension,k);

res = zeros(k*cntOfDimension,cnt);

record = zeros(1,k);
r = 0;
for i = 1:k
    
    t = randi(cnt);
    
    if i > 1 && t == r
        i = i - 1;
        continue;
    end
    
    seed(:,i) = data(:,t);
    r = t;
end

while 1
    record(:) = 0;
    res(:) = 0;
    res_index(:)=0;
    for i = 1:cnt
        
        distanceMin = 1;
        for j = 2:k
            a = 0;
            b = 0;
            for row = 1:cntOfDimension
                a = a + power(data(row,i)-seed(row,distanceMin),2);
                b = b + power(data(row,i)-seed(row,j),2);
            end
            if a > b
                distanceMin = j;
            end
        end
        
        row = (distanceMin-1)*cntOfDimension + 1;
        res(row:row+cntOfDimension-1,record(distanceMin)+1) = data(:,i);
        res_index(row:row+cntOfDimension-1,record(distanceMin)+1)=i;
        record(distanceMin) = record(distanceMin)+1;
    end
    
    oldSeed = seed;
    
    for col = 1:k
        if record(col) == 0
            continue;
        end
        
        row = (col-1)*cntOfDimension + 1;
        seed(:,col) = sum(res(row:row+cntOfDimension-1,:),2)/record(col);
    end
    
    if mean(seed == oldSeed) == 1
        break;
    end
end

maxPos = max(record);
res = res(:,1:maxPos);
final_index=zeros(2,maxPos);
if size(res_index,1)>3
    final_index(1,:)=res_index(1,1:maxPos);
    final_index(2,:)=res_index(4,1:maxPos);
else
    final_index(1,1:80)=res_index(1,1:80);
    final_index(2,1:maxPos-80)=res_index(1,81:maxPos);
    record=[80 12];
end


end
