defmodule Proj2.GossipPushSum do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  #use Application
  #use Topologies
  import Supervisor, warn: false
  def main(args \\ []) do
    
    
    {_ ,[noOfNodes, topology , algorihm],_} = OptionParser.parse(args ,  strict: [n: :integer, k: String, o: String])
    #case OptionParser.parse(System.argv() ,  strict: [n: :integer, k: String, o: String]) do
  
      #{_ ,[noOfNodes, topology , algorihm],_} -> divideArgAndCallFunc(String.to_integer(a),\\b))  ### For Nodes
      #{_ ,[a,b],_} -> app(String.to_integer(a),String.to_integer(b))
     # _ -> app(1,2)
      #end
    
        noOfNodes = String.to_integer(noOfNodes)
       #failure_percentage = String.to_integer(failure_percentage)
        #noOfFailedNodes = trunc(failure_percentage*noOfNodes/100)
        #algorihm = "gossip"
        #topology = "line"
        
        {:ok, _pid} =   MySupervisor.start_link([noOfNodes,algorihm])


      #no_of_nodes = [30, 50, 100,500, 1000,1500, 2000,2500, 3000, 3500, 4000, 4500, 5000]
    

    #Topologies.full_network(noOfNodes,algorihm)
    #threeDtorus_network(noOfNodes,algorihm)
    if check_args(noOfNodes, topology, algorihm ) == true do
    organize_nodes_in_topology(noOfNodes , topology , algorihm)
    NodeInfo.initiate_algorithm(algorihm)
    
    print_convergence_time("anyvalue",0)
    end

    #{:ok, pid}
    
  end
  
  defp check_args(noOfNodes , topology , algorihm) do
    
    topology_list = ["full","line","rand2D","3Dtorus","honeycomb","randhoneycomb"]
    algorithm_list = ["gossip","push-sum"]
    cond do
        
        noOfNodes <= 1 || !Enum.member?(topology_list,  topology) || !Enum.member?(algorithm_list,  algorihm)
        -> IO.puts "One or more Input Arguments not valid, Valid Values"
         IO.puts ""
         IO.inspect topology_list
         IO.puts ""
         IO.inspect algorithm_list
         IO.puts ""
         IO.puts "Minimum no of Nodes are 2 required"
         false
         true -> true


    end

  end

  defp organize_nodes_in_topology( noOfNodes , topology , algorihm ) do
    
    case topology do
      
      "full" -> Topologies.full_network(noOfNodes,algorihm)
      "line" -> Topologies.line_network(noOfNodes,algorihm)
      "rand2D" -> Topologies.random2D_network(noOfNodes,algorihm)
      "3Dtorus" -> 
        
        gridLength = trunc( ceil(:math.pow(noOfNodes,1/3) ) )
        noOfNodes = gridLength*gridLength*gridLength 
        Topologies.threeDtorus_network(noOfNodes,algorihm)
        
      "honeycomb" -> Topologies.honeycomb_network(noOfNodes,algorihm)
      "randhoneycomb" -> Topologies.hcrand_network(noOfNodes,algorihm)
      
    end

  end
 

  
  
  def print_convergence_time(msg, n) when n > 0 do
    IO.puts msg
  end

  def print_convergence_time(msg,n) do
    {end_time,start_time,_list_of_nodes} = NodeInfo.get() 
   # IO.inspect NodeInfo.get()
    if  end_time != 0 do
      print_convergence_time(end_time - start_time,1)
    else
       print_convergence_time(msg,n)
    end   
  end

end
