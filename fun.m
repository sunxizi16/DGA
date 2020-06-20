function [Qpct,Q] = fun(u)
%Evaluate the noise scaling factor Q for each code sequence
% u                input : the code sequence
% f                 input: the estimated envelop function
% n_DTFT    input : 2^n_DTFT is the poin of discrete Fourier transform
% F_E           input: Energy enhancement factor
%Q                output: the noise scaling factor
%Qpct           output: the ratio of standard reference coding gain to the coding gain (i.e. Gr/Gc)
global  f n_DTFT F_E;
u_f=u.*f;
decoder=fftshift(fft(u_f,2^n_DTFT));
Q=mean(1./abs(decoder.^2));
Qpct=sqrt(F_E/2)*sqrt(Q);







