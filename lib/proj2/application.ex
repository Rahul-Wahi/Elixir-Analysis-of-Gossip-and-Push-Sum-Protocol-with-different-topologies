defmodule Proj2.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor, warn: false
  def start(_type, _args) do
    
   # case OptionParser.parse(System.argv() ,  strict: [n: :integer, k: :integer]) do
  
    #  {_ ,[a,b],_} -> divideArgAndCallFunc(String.to_integer(a),String.to_integer(b))  ### For Nodes
      #{_ ,[a,b],_} -> app(String.to_integer(a),String.to_integer(b))
     # _ -> app(1,2)
      #end
    
        noOfNodes = 1000
        algorihm = "gossip1"
      
          {:ok, pid} =   MySupervisor.start_link([noOfNodes,algorihm])

   
    full_network(noOfNodes,algorihm)
    
    NodeInfo.initiate_algorithm(algorihm)
    
    print_convergence_time("anyvalue",0)
    {:ok, pid}
    
  end
  
  
  defp full_network(noOfNodes, algorithm) do

    task_struct = Enum.map( 1 ..noOfNodes , fn x->  Process.whereis(String.to_atom(Integer.to_string(x))) end)
    if String.contains?(algorithm,"gossip") do
    Enum.each(task_struct, fn x -> Gossip.set_neigbours(x, task_struct -- [x]) 
 
      end)
  else
    Enum.each(task_struct, fn x -> PushSum.set_neigbours(x, task_struct -- [x]) 
    
         end)
    end
  end
   
  def print_convergence_time(msg, n) when n > 0 do
    IO.puts msg
  end

  def print_convergence_time(msg,n) do
    {end_time,start_time} = NodeInfo.get() 
    
    if  end_time > 0 do
      print_convergence_time(end_time - start_time,1)
    else
       print_convergence_time(msg,n)
    end   
  end

end
