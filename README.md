# Proj2

NAME 1: Rahul Wahi
UFID: 3053-6162

NAME 2: Wins Goyal
UFID: 7357-1559

*************************************************************************************************************************
1. **STEPS to run the code**
  
step1: Unzip the file and enter in the proj2 folder through terminal($cd proj2) where mix.exs file is present.

If needed to build the script again, then run
mix escript.build

step2:run the the following command to execute the file.

For Linux
./proj2 numOfNodes topology algorithm

For Windows
escript proj2 numOfNodes algorithm

Output:-
Convergence time

*********************************************************************************************
For Bonus:
Unzip the bonus file and cd proj2 folder and run the following command

For Linux
./proj2 numOfNodes topology algorithm percentageFailure

For Windows
escript proj2 numOfNodes algorithm percentageFailure

Output:-
Convergence time
Number of Unreached Nodes

*************************************************************************************************

-Program is working for all the topologies for both algorithms

System Configuration: 8GB RAM, i5
Based on System Configuration maximum numbers of nodes for each topologies vary based on the system configuration

For Gossip, Largest Network for topologies
full = 8000 (Convergence time 64 secs , for more than 8000 getting memory overflow error )
line =  10000 (Covergence time too high)
random2D = 50000 (Convergence time around 5 secs)
3Dtorus = 50000 (Convergence time 6.3 secs)
honeycomb = 20000 (Convergence time 30 secs)
randhoneycomb = 100000 ()

For Push-Sum, Largest Network for topologies
full = 5000 (Convergence time 400 secs)
line = 5000 (Convergence time 68.4 secs)
random2D = 2000 (Convergence time 100.8 secs)
3Dtorus = 2000 (Convergence time 57.2 secs)
honeycomb = 2000 (Convergence time 1112 secs)
randhoneycomb = 10000 (Convergence time 12.4 secs)


Additional details about the analysis can be found in report.pdf
