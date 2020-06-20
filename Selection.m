function ret=Selection(S,Qpct,beta)
% Update a given subpoplation using a typical roulette wheel selection
% S               input  : the subpoplation
% Qpct         input  :  the ratio of standard reference coding gain to the coding gain (i.e. Gr/Gc)
% beta         input  : number of sequences in each subpopulation
% ret           output : the subpoplation after Selection operation

Qpct= 1./(Qpct);
sumfitness=sum(Qpct);
P=Qpct./sumfitness;%the survival probability of each sequence
index=[];
for i=1:beta   
    Pr=rand;%Generate a random number between 0 and 1
    while Pr==0
        Pr=rand;
    end
    for j=1:beta
        Pr=Pr-P(j);
        if Pr<0
            index=[index j];
            break;  
        end
    end
end

ret=S(index,:);