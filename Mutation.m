function ret=Mutation(S,Pmutation,Nmutation,beta)
% Tweak the bit value of a sequence
% S                    input : the subpoplation
% Pmutation     input : mutation probability
% Nmutation     input : bit number of mutation
% beta               input : number of sequences in each subpopulation
% Nu                  input : total bit number of a sequence
% ret                 output : the subpoplation after Mutation operation

global Nu;
for i=1:beta
    pick=rand;%mutation probability
    if pick>Pmutation
        continue;
    end
    
    pick=rand;
    while pick==0
        pick=rand;
    end
    index=ceil(pick*beta);%Randomly chose sequences

    pick=rand(1,Nmutation);
    while prod(pick)==0
        pick=rand(1,Nmutation);
    end
    pos=ceil(pick*Nu); %ramdon mutation point
   
    v=S(index,pos);
    for j=1:size(v,2)%tweak the bit value
        if v(j)==0
            S(index,pos(j))=1;
        else
            S(index,pos(j))=0;
        end
    end
end

ret=S;