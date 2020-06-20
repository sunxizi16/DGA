clc;clear all;
warning off;
% DGA for a unipolar binary code sequence with total number Nu=120 and energy enhancement factor F_E=40.
global F_E Nu n_DTFT f n1 alpha;
%% Parameters setting of GO-code
F_E=40;% Energy enhancement factor
m=3;
Nu=m*F_E;%Total bit number of a sequence
n_DTFT=12;%2^n_DTFT is the point of discrete Fourier transform.

%%  EDFA gain saturation
% Here the envelop function is simulated using an exponential function. 
% In the practical system, the envelop function can be estimated based on EDFA specifications.
EDFA_fading = 0.15; 
f=exp(-EDFA_fading*linspace(0,1,Nu));%Simulated envelop function
n1=round(Nu/(sum(f)/F_E));% the initial bit number of '1' in a code sequence

%% Parameters setting of DGA
alpha=60;%Number of subpopulations
beta=60;%Number of individuals in each subpopulation
Pcross=0.8+(0.9-0.8)*rand(alpha,1);%Crossover probability
Ncross=21;%Bit number of alternating segments
Pmutation=0.2+(0.4-0.2)*rand(alpha,1);%Mutation Probability
Nmutation=19;%Bit number of mutation
phi=60;%Migration interval
gama=12;%Number of migrants
mu=60;%Generation counter

%% Initialization
counter=0;
counter1=0;
Ymin=2;Y=[];
Smin=ones(alpha,Nu);
Qpctmin=2*ones(alpha,1); %Initialize the minimum ratio of standard reference coding gain to the coding gain 
%Randomly initialize alpha*beta code sequences
individuals0=struct('u',zeros(beta,Nu),'fitness',zeros(beta,1),'fitness_Q',zeros(beta,1));
for j=1:alpha
    for i=1:beta
        individuals0.u(i,:)=Code;
        [individuals0.fitness(i),individuals0.fitness_Q(i)]=fun(individuals0.u(i,:));%Evaluate the ratio of standard reference coding gain to the coding gain,  the noise scaling factor Q for each code sequence
    end
    individuals(j)=individuals0;
end
S={individuals.u};
Qpct={individuals.fitness};
Q={individuals.fitness_Q};

%% DGA
tic;
while counter<=mu
    counter1=counter1+1;
    for i=1:alpha
        [bestQpct, bestindex]=min(Qpct{i});
        bestS=S{i}(bestindex,:);
        bestQ=min(Q{i});
        for k=1:phi
            S{i}=Selection(S{i},Qpct{i},beta);%Selection operator
            S{i}=Crossover(S{i},Pcross(i),Ncross,beta);%Crossover operator
            S{i}=Mutation(S{i},Pmutation(i),Nmutation,beta);%Mutation operator
            for j=1:1:beta
                [Qpct{i}(j),Q{i}(j)]=fun(S{i}(j,:));%Update the noise scaling factor
            end
            
            %Replace the code sequence with smaller Q if its energy enhance factor deviate from F_E
            [~,aa]=sort(Qpct{i});
            bb=abs(sum(S{i}(aa,:).*repmat(f,beta,1),2)-F_E)>2;
            for j=1:1:length(bb)
                if bb(j)==1%The energy enhance factor deviate from F_E
                    S{i}(aa(j),:)=Code;
                    [Qpct{i}(aa(j)),Q{i}(aa(j))]=fun(S{i}(aa(j),:));
                else
                    break
                end
            end
            
            [newbestQpct,newbestindex]=min(Qpct{i});
            [~,worestindex]=max(Qpct{i});
            if bestQpct>newbestQpct
                bestQpct=newbestQpct;
                bestS=S{i}(newbestindex,:);
                bestQ=Q{i}(newbestindex);
            end
            S{i}(worestindex,:)=bestS;
            Qpct{i}(worestindex)=bestQpct;
            Q{i}(worestindex)=bestQ;
        end     
    end
    
    [S,Qpct]=Migrantion(S,Qpct,gama);%Migration operator
    [Smin,Qpctmin]=EliteInduvidual(S,Qpct,Smin,Qpctmin);%The sequence with minimum Q (Qpct) in each subpopulation
    [Y(counter1),index]=min(Qpctmin);%The minimum Q (Qpct) among all subpopulations
    X=Smin(index,:);%The sequence with minimum Q (Qpct) among all subpopulations
    
    if Y(counter1)<Ymin%If the sequence with minimum Q (Qpct) is update
        ubest=X;%The best sequence
        F_E1=sum(ubest.*f);%The energy enhance factor of ubest
        Ymin=Y(counter1);%The Qpct of ubest
        disp(['noise scaling factor Q= ',num2str(Ymin^2/(F_E*2)),', coding gain Gc=',num2str(sqrt(F_E/2)/Ymin),', Gc/Gr=',num2str(100/Ymin),'%']);
        counter=0;
    else
        counter=counter+1;
    end
    
end

time=toc;%Computing time, unit: second

%% Save data
Filen=['Nu=',num2str(Nu),', F_E=', num2str(F_E1),', Gc=',num2str(sqrt(F_E/2)/Ymin),'.mat'];
save(Filen,'-mat');

%% Plot figure
% Blue bars present coding gain distribtion of last subpopulation.
% Red line presents the standard reference coding gain.
Q1=zeros(alpha*beta,1);
for j=1:1:length(Q)
   Q1(1+(j-1)*beta:j*beta)=Q{j};
end
Gc=sqrt(1./Q1);
delta=0.05;
order=sqrt(F_E/2)/delta-floor(sqrt(20)/delta):1:sqrt(F_E/2)/delta;
probability=zeros(1,length(order));
for j=2:1:length(order)
    probability(j) = numel(find(Gc>delta*order(j-1)&Gc <=delta*order(j)))/length(Q1);
end
figure;hold on;box on;grid on;
h=bar(delta.*order-delta./2,probability,1);
set(h,'EdgeColor','k','FaceColor',[0 0.45 0.74]);
plot([sqrt(F_E/2) sqrt(F_E/2)],[0 max(probability)],'linesty','-','linewidth',2,'Color','r');
xlim([0 ceil(sqrt(F_E/2))]);ylim([0 max(probability)]);
set(gca,'xtick',0:1:ceil(sqrt(F_E/2)));
set(gcf, 'Position', [1, 1, 560, 420]);set(gca,'fontname','Arial','FontSize',20);set(gca, 'Position', [0.2, 0.187, 0.75, 0.79]);
xlabel('G_c','Fontsize',22,'fontname','Arial','Position',[2.5,-0.005,0]);ylabel('Probability','Fontsize',22,'fontname','Arial');
axes('Position', [0.62, 0.63, 0.75/2.5, 0.79/2.5]);hold on;box on;grid on;   
h=bar(delta.*order-delta./2,probability,1);
set(h,'EdgeColor','k','FaceColor',[0 0.45 0.74]);
plot([sqrt(F_E/2) sqrt(F_E/2)],[0 max(probability)],'linesty','-','linewidth',2,'Color','r');
xlim([roundn(sqrt(F_E/2),-3)-1.5 roundn(sqrt(F_E/2),-3)]);ylim([0 max(probability(end-20:end))]);
set(gca,'xtick',roundn(sqrt(F_E/2),-3)-1.5:0.5:roundn(sqrt(F_E/2),-3));
set(gca,'fontname','Arial','FontSize',14);


