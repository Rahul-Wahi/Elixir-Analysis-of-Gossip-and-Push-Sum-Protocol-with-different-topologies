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
    
        noOfNodes = 200
        algorihm = "gossip1"
      
          {:ok, pid} =   MySupervisor.start_link([noOfNodes,algorihm])

   # mapChildren(noOfNodes)
    #IO.inspect (pid)
    full_network(noOfNodes,algorihm)
    NodeInfo.initiate_algorithm(algorihm)
    :timer.sleep(2000);
   # IO.inspect NodeInfo.get()
   # Enum.each(1..1,  fn x -> mapChildren(noOfNodes)
    # :timer.sleep(2000); end )
    print_convergence_time("h",0)
    {:ok, pid}
    
  end
  
  defp mapChildren(noOfNodes) do
     #Enum.map( 1 ..100 , fn x->   Gossip.get(Process.whereis(String.to_atom(Integer.to_string(x) ) )) 
     # end)

    #IO.inspect Gossip.get(Process.whereis(String.to_atom(Integer.to_string(1) ) ))
    task_struct = Enum.map( 1 ..noOfNodes  , fn x ->  Process.whereis(String.to_atom(Integer.to_string(x))) end)
    
    Enum.each(1..1000,  fn x -> IO.puts length(Enum.filter(task_struct, fn x when x !=nil-> Process.alive?(x) end ))
     :timer.sleep(50); end )
    


    #IO.inspect task_struct
  end
  
  defp full_network(noOfNodes, algorithm) do

    task_struct = Enum.map( 1 ..noOfNodes , fn x->  Process.whereis(String.to_atom(Integer.to_string(x))) end)
    if String.contains?(algorithm,"gossip") do
    Enum.each(task_struct, fn x -> Gossip.set_neigbours(x, task_struct -- [x]) 
 # IO.inspect(Gossip.get(x)) end)
      end)
  else
    Enum.each(task_struct, fn x -> PushSum.set_neigbours(x, task_struct -- [x]) 
    # IO.inspect(Gossip.get(x)) end)
         end)
    end
  end
   # Gossip.recieveRumour(Enum.at(task_struct,1), "r")
  def print_convergence_time(msg, n) when n >= 1 do
    IO.puts msg
  end

  def print_convergence_time(msg,n) do
    {numOfNodes,start_time,list} = NodeInfo.get() 
    if  length(list) >= 0.7 * numOfNodes do

      print_convergence_time(Enum.at(list,length(list) -1 ) - start_time,1)
    else
      IO.puts length(list)
      IO.inspect NodeInfo.get() 
      print_convergence_time(msg,0)
    end   
  end


  

end
