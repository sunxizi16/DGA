function [Smin,Qpctmin]=EliteInduvidual(S,Qpct,Smin,Qpctmin)
% Output the sequence with minimum Q (Qpct) in each subpopulation
% S                   input : the subpoplation
% Qpct             input  :  the ratio of standard reference coding gain to the coding gain (i.e. Gr/Gc)
% alpha            input : number of subpopulations
% Smin            output : the sequence with minimum Q in each subpopulation
% Qpctmin       output : the minimum Qpct in each subpopulation
global alpha;
for i=1:alpha
    [MinO,minindex]=min(Qpct{i});   
    if MinO<Qpctmin(i)
        Qpctmin(i)=MinO;        
        Smin(i,:)=S{i}(minindex,:);  
    end
end
