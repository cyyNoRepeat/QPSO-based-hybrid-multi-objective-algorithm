function f = Normalization(x,M)   %��ʱ��x�Ǻ�������������ģ���һ��
N = size(x,1);
for i = 1 : N
    for j = 1 : M
        f_max = max(x(:,1+j));
        f_min = min(x(:,1+j));
        if f_max - f_min == 0
            x(i,1+j) = 1;
        else
             x(i,1+j) = (x(i,1+j) - f_min)/(f_max - f_min);  
        end
    end
end
f = x;


