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
        algorihm = "gossip"
      
          {:ok, pid} =   MySupervisor.start_link([noOfNodes,algorihm])

   
    full_network(noOfNodes,algorihm)
    #threeDtorus_network(noOfNodes,algorihm)
    

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

  defp threeDtorus_network(noOfNodes, algorithm) do
    task_struct = Enum.map( 1 ..noOfNodes , fn x->  Process.whereis(String.to_atom(Integer.to_string(x))) end)

    if String.contains?(algorithm,"gossip") do
      Enum.each(1 ..noOfNodes, fn x -> Gossip.set_neigbours( Enum.at( task_struct , x-1 ) , find_3dtorus_neighbours(task_struct, noOfNodes, x) ) 
   
        end)
    else
      Enum.each(1 ..noOfNodes, fn x -> PushSum.set_neigbours( Enum.at( task_struct , x-1 ) , find_3dtorus_neighbours(task_struct, noOfNodes, x) ) 
      
           end)
      end
      #Enum.each(task_struct, fn x -> IO.inspect(x)
       #IO.inspect Gossip.get(x) end ) 

  end

  #will return the list of neighboours for specified node_number
  defp find_3dtorus_neighbours(task_struct, noOfNodes, node_number) do
  
    grid_length = trunc( :math.pow(noOfNodes,1/3) );
    neighbour1 = Enum.at( task_struct , first_neighbour_3d(node_number, grid_length) -1 )
    neighbour2 = Enum.at( task_struct , second_neighbour_3d(node_number, grid_length) -1 )
    neighbour3 = Enum.at( task_struct , third_neighbour_3d(node_number, grid_length) - 1 )
    neighbour4 = Enum.at( task_struct , fourth_neighbour_3d(node_number, grid_length) -1 )
    neighbour5 = Enum.at( task_struct , fifth_neighbour_3d(node_number, grid_length) -1 )
    neighbour6 = Enum.at( task_struct , sixth_neighbour_3d(node_number, grid_length) -1 )

    _list_neighbours = [neighbour1 , neighbour2 , neighbour3, neighbour4, neighbour5, neighbour6]
    
  end

  defp first_neighbour_3d(node_number, grid_length) do
  
    if rem(node_number,grid_length) == 0 do
      node_number - grid_length + 1
    else
      node_number + 1
    end
    
  end

  defp second_neighbour_3d(node_number, grid_length) do
  
    if node_number + grid_length > grid_length*grid_length*grid_length do
      node_number + grid_length - grid_length*grid_length
    else
      node_number + grid_length
    end
    
  end

  defp third_neighbour_3d(node_number, grid_length) do
  
    if node_number + grid_length*grid_length > grid_length*grid_length*grid_length do
      node_number + grid_length*grid_length - grid_length*grid_length*grid_length
    else
      node_number + grid_length*grid_length
    end
    
  end 

  defp fourth_neighbour_3d(node_number, grid_length) do
  
    if rem( node_number - 1 , grid_length ) == 0 do
      node_number - 1 +  grid_length
    else
      node_number - 1 
    end
    
  end 

  defp fifth_neighbour_3d(node_number, grid_length) do
  
    if  node_number - grid_length <   0 do
      node_number - grid_length +  grid_length*grid_length
    else
      node_number - grid_length 
    end
    
  end

  defp sixth_neighbour_3d(node_number, grid_length) do
  
    if  node_number - grid_length*grid_length <   0 do
      node_number - grid_length*grid_length +  grid_length*grid_length*grid_length
    else
      node_number - grid_length*grid_length*grid_length
    end
    
  end

  
  
  def print_convergence_time(msg, n) when n > 0 do
    IO.puts msg
  end

  def print_convergence_time(msg,n) do
    {end_time,start_time,_list_of_nodes} = NodeInfo.get() 
   # IO.inspect NodeInfo.get()
    if  end_time > 0 do
      print_convergence_time(end_time - start_time,1)
    else
       print_convergence_time(msg,n)
    end   
  end

end
