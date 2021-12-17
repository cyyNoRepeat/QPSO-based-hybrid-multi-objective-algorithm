function f  = chaotic_mutation(search_population,pop_size,deadline,number_dvar,state,activity,no_mode,resource_available,initialization,lim,num_k)
lim_chaotic=0.8;
interval=65;
ini_ie0=initialization(:,3);
dr_ie0=initialization(:,4);
parfor i=1:pop_size
    byh_st=zeros(1,num_k);
    byh_mode=zeros(1,num_k);
    
    temp_st=[];
    temp_mode=[];
    if rand(1)<=lim_chaotic
        for j=1:number_dvar/num_k
            duration1=150;
            byh_st(1)=randi([interval+15,duration1]);
            ini1=0.2*(ini_ie0(j)+dr_ie0(j)*byh_st(1))-0.2;
            dr1=dr_ie0(j)*1.1;
            duration2=floor((lim(j)-ini1)/dr1);
            
            byh_st(2)=randi([byh_st(1)+interval+40,byh_st(1)+duration2]);
            
            byh_st(2)=randi([byh_st(1)+40,deadline]);
            
            
            temp_st=[temp_st,byh_st];
            byh_mode(1)=randi(no_mode);
            byh_mode(2)=randi(no_mode);
            
            temp_mode=[temp_mode,byh_mode];
        end
        mutation_population(i,:)=[temp_mode,temp_st];
        
        mutation_value=evaluate(mutation_population(i,:),number_dvar,state,activity,resource_available,deadline,initialization,lim,num_k);
        search_value=evaluate(search_population(i,:),number_dvar,state,activity,resource_available,deadline,initialization,lim,num_k);
        if mutation_value(1)<search_value(1)
            mutation_population(i,:)=[temp_mode,temp_st];
        else
            mutation_population(i,:)= search_population(i,:);
        end
    else
        mutation_population(i,:)= search_population(i,:);
    end
end
f = mutation_population;


