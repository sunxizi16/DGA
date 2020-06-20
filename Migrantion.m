function [S,Qpct]=Migrantion(S,Qpct,gama)
% Exchange the sequence among subpopulations
% S                   input : the subpoplation
% Qpct             input  :  the ratio of standard reference coding gain to the coding gain (i.e. Gr/Gc)
% gama           input : number of migrants
% alpha            input : number of subpopulations
% ret                output : the subpoplation after Mutation operation

global alpha;
for i=1:alpha
    [~,minindex]=sort(Qpct{i});
    next_i=i+1;
    if next_i>alpha;
        next_i=mod(next_i,alpha);
    end
    [~,maxindex]=sort(Qpct{next_i},'descend'); 
    
    S{next_i}(maxindex(1:gama),:)=S{i}(minindex(1:gama),:);%Exchange
    Qpct{next_i}(maxindex(1:gama))=Qpct{i}(minindex(1:gama));
end
