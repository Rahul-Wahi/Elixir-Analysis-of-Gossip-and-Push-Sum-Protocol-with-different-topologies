# Proj2

NAME 1: Rahul Wahi  
UFID: 3053-6162  
  
NAME 2: Wins Goyal  
UFID: 7357-1559  
  
*************************************************************************************************************************
1. **STEPS to run the code**
   
__step1:__ Unzip the file and enter in the "proj2" folder through terminal **($cd proj2)** or where *mix.exs* file is present.  
  
If needed to build the script again, then run  
>>> mix escript.build
  
__step2:__ Run the the following command to execute the file.  
  
For Linux  
>>> ./proj2 numOfNodes topology algorithm

For Windows  
>>> escript proj2 numOfNodes algorithm

__Output__:-  
'''Convergence time'''

*************************************************************************************************
2. **For Bonus:**  
   
__step1:__ Unzip the bonus file and enter into the folder where *mix.exs* file is present.  
  
If needed to build the script again, then run  
>>> mix escript.build  

For Linux  
>>> ./proj2 numOfNodes topology algorithm percentageFailure  
  
For Windows  
>>>  escript proj2 numOfNodes algorithm percentageFailure  
  
__Output__:-
'''Convergence time
Number of Unreached Nodes'''

*************************************************************************************************
3. **What is working?**
  
- Program is working for all the topologies for both algorithms
  
- System Configuration: 8GB RAM, i5
Maximum numbers of nodes for each topologies vary based on the System's configuration and its computational resources.

*************************************************************************************************
4. **Gossip and Push-Sum, Max. nodes computed for convergence**
  
For Gossip, Largest Network for topologies  
full = 8000 (Convergence time 64 secs, for more than 8000 getting memory overflow error)  
line =  10000 (Covergence time too high)  
random2D = 50000 (Convergence time around 5 secs)  
3Dtorus = 50000 (Convergence time 6.3 secs)  
honeycomb = 20000 (Convergence time 30 secs)  
randhoneycomb = 20000 (Convergence time 2.5 secs)  

For Push-Sum, Largest Network for topologies  
full = 5000 (Convergence time 400 secs)  
line = 5000 (Convergence time 68.4 secs)  
random2D = 2000 (Convergence time 100.8 secs)  
3Dtorus = 2000 (Convergence time 57.2 secs)  
honeycomb = 2000 (Convergence time 1112 secs)  
randhoneycomb = 10000 (Convergence time 12.4 secs)  
  
  
Additional details about the analysis can be found in report.pdf  
