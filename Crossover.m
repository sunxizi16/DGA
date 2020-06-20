function ret=Crossover(S,Pcross,Ncross,beta)
% Alternate segments of code sequences
% S               input : the subpoplation
% Pcross     input : crossover probability
% Ncross     input : bit number of alternating segments
% beta         input : number of sequences in each subpopulation
% Nu            input : total bit number of a sequence
% ret           output : the subpoplation after Crossover operation

global Nu;
for i=1:beta
    pick=rand;
    while pick==0
        pick=rand;
    end
    if pick>Pcross%crossover probability
        continue;
    end
    
    pick=rand(1,2);
    while prod(pick)==0
        pick=rand(1,2);
    end
    index=ceil(pick.*beta);%Randomly chose two sequences
    
    pick=rand;
    while pick==0
        pick=rand;
    end
    pos=ceil(pick.*Nu); 
    if pos>Nu-Ncross
        pos=pos-Ncross;% random crossover point
    end
    
    v1=S(index(1),pos:pos+Ncross); %Ncorss-bit-long segments are swapped
    v2=S(index(2),pos:pos+Ncross);
    S(index(1),pos:pos+Ncross)=v2;
    S(index(2),pos:pos+Ncross)=v1; 
end

ret=S;
