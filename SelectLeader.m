function [Gbest,Gbest_value] = SelectLeader(elite,elite_value,GridIndex,beta)

    % Grid Index of All Repository Members
    GI = GridIndex;
    
    % Occupied Cells
    OC = unique(GI);
    
    % Number of Particles in Occupied Cells
    N = zeros(size(OC));
    for k = 1:numel(OC)
        N(k) = numel(find(GI == OC(k)));
    end
    
    % Selection Probabilities
    P = exp(-beta*N);
    P = P/sum(P);
    
    % Selected Cell Index
    sci = RouletteWheelSelection(P);
    
    % Selected Cell
    sc = OC(sci);
    
    % Selected Cell Members
    SCM = find(GI == sc);
    
    % Selected Member Index
    smi = randi([1 numel(SCM)]);
    
    % Selected Member
    sm = SCM(smi);
    
    % Leader
    Gbest = elite(sm,:);
    Gbest_value = elite_value(sm,:);

end