# Distributed genetic algorithm (DGA)

## Contents
- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Input Parameters](#input-parameters)
- [Demo](#demo)
- [Results](#results)
- [Citation](#citation)

# Overview
Distributed genetic algorithm (DGA) is a MATLAB script that contains all the required functions to search for an optimal/sub-optimal unipolar binary code sequence, here called genetic-optimised code (GO-code), aiming to offer the largest possible coding gain. In this script, a set of input parameters is adjustable, among which the energy enhancement factor `F_E` can be modified according to a given system. Other parameters relevant to the searching process are fixed (see Section Input Parameters), since they keep efficient in different searching targets thanks to the robustness of DGA. Additionally, in the demo, we provide a decaying trend to code sequence envelop to take into account the EDFA gain saturation. In practical systems, this decaying trend is determined by the specifications of EDFA and can be estimated by measuring the coding sequence.

# System Requirements

## Hardware Requirements

The DGA requires only a standard computer with enough RAM to support in-memory operations. For an optimal performance, we recommend a computer with following specs:

RAM: 16+ GB     
CPU: 4+ cores, 2.5+ GHz/core

The runtime below results from a computer with recommended specs (16 GB, 4 cores@2.5 GHz).

## Software Requirements

The DGA is realised by a MATLAB script that requires only a working version of MATLAB. We recommend a version higher than MATLAB R2015a. A simple installation on the computer could probability just be done with [MATLAB official website.](https://www.mathworks.com/)    

The results below are performed using MATLAB R2015a routine.


# Input Parameters 

## Parameters setting of GO-code
Three parameters are set for GO-code:   
1) `F_E`: energy enhancement factor, which can be modified by users to search GO-code with specified coding gain;    
2) `m`: the ratio of code length to energy enhancement factor, which is suggested to be a number between 3 and 4 according to the computational efficiency and effectiveness;    
3) `f`: the decaying trend applied to sequence envelop to take into account the EDFA gain saturation. `f` is determined by the specifications of EDFA used in practical system and can be estimated by measuring the coding sequence.

## Parameters setting of DGA
Number of subpopulations `alpha`=60;  
Number of individuals in each subpopulation `beta`=60;   
Crossover probability `Pcross`: random value between 0.8 and 0.9;   
Bit number of alternating segments `Ncross`=19;    
Mutation probability `Pmutaion`: random value between 0.2 and 0.4;      
Bit number of mutation `Nmutation`=21;     
Migration interval `phi`=60;    
Number of migrants `gama`=12;    
Generation counter `mu`=60.

The input parameters of DGA are verified experimentally to be robustness in the search of GO-code. It is not necessary to tune all these parameters for a specific sequence length.

# Demo
In the demo script, a unipolar binary code sequence with total bit number `Nu` = 120 and energy enhancement factor `F_E`= 40 is searched using DGA with parameters setting mentioned above.  
    
* The parameters of code sequence:      

        F_E=40;   
        m=3;      
    

* The decaying trend, here it is represented using an exponential function:
  
        EDFA_fading = 0.15;
        f=exp(-EDFA_fading*linspace(0,1,Nu)); 

* Input the following command to run the demo script:

        run('Demo.m');
* The algorithm terminates when the counter value reaches `mu` and the final solution of code sequence `ubest` is saved naming as the following format:     
        
        ubest_Nu=  , F_E=  , Gc=  .mat 
where `Nu`, `F_E` and `Gc` are total bit number, energy enhancement factor and coding gain of `ubest`, respectively.

# Results
Note that due to the random initialization and genetic operation, a different code sequence is likely to be delivered each time users run the same script, but all the delivered code sequences can offer coding gains close to the standard reference coding gain. Here we upload a coding sequence computed by the demo script. Users can check this sequence by the following command: 
 
    load('ubest_Nu=120, F_E=41.3428, Gc=4.1885.mat');

* During the searching process, values of noise scaling factor `Q`, coding gain `Gc`, ratio of coding gain to standard reference coding gain `Gc/Gr` will be printed in the command window if a code sequence with smaller noise scaling factor `Q` is found:   
![image](https://github.com/sunxizi16/DGA/blob/master/result1.png)      
The last row shows `Q`, `Gc` and `Gc/Gr` of the delivered best code sequence.

* When the search completes, the delivered best code sequence `ubest` will be printed in the command window:   
![image](https://github.com/sunxizi16/DGA/blob/master/result3.jpg.png) 

* When the search completes, the `Gc` distribution of last subpopulation will be figured:   
![image](https://github.com/sunxizi16/DGA/blob/master/result2.jpg) 
   
* The upload result is computed in 124 minutes on a computer with the recommended specs. 


# Citation
If you use this algorithm for your research, please cite the following paper:

