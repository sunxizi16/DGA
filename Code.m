function ret=Code()
%Randomly initialize a code sequence
% Nu          input : total bit number of a code sequence
% n1             input : the bit number of '1'
% ret            output: the code sequence
global Nu n1 ;
ret=zeros(1,Nu);
pick=randperm(Nu,n1);
ret(sub2ind(size(ret),pick))=1;

