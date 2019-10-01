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
        #algorihm = "gossip"
        #topology = "line"
        
        {:ok, _pid} =   MySupervisor.start_link([noOfNodes,algorihm])


   
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
        if(noOfNodes < 27) do
          IO.puts ("For 3Dtorus minimum no. of nodes should be 27, please re run with correct value")
        else
        gridLength = trunc( :math.pow(noOfNodes,1/3) )
        noOfNodes = gridLength*gridLength*gridLength 
        Topologies.threeDtorus_network(noOfNodes,algorihm)
        end
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
