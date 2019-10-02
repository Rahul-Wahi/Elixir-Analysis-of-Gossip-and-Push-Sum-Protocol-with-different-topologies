defmodule Topologies do
    #defmacro __using__(_) do
     #   quote do
    def full_network(noOfNodes, algorithm) do

        task_struct = Enum.map( 1 ..noOfNodes , fn x->  Process.whereis(String.to_atom(Integer.to_string(x))) end)
        if String.contains?(algorithm,"gossip") do
        Enum.each(task_struct, fn x -> Gossip.set_neigbours(x, task_struct -- [x]) 
     
          end)
      else
        Enum.each(task_struct, fn x -> PushSum.set_neigbours(x, task_struct -- [x]) 
        
             end)
        end
      end
    
      def line_network(noOfNodes, algorithm) do
        # e.g. [1,2,3,4,5,6] => [[1,2,3], [2,3,4], [3,4,5], [4,5,6]]
        # need [1,2] and [5,6] at the ends
        # Create [1,2] from [1,2,3] and create [5,6] from [4,5,6]
        task_struct = Enum.map( 1..noOfNodes, fn x -> Process.whereis(String.to_atom(Integer.to_string(x))) end ) 
                  |>  Enum.chunk_every(3, 1, :discard)          
        [first_node, f_neighbour] = Enum.slice(Enum.at(task_struct, 0), 0, 2)
        [l_neighbour, last_node] = Enum.slice(Enum.at(task_struct, -1), -2, 2)
    
        if String.contains?(algorithm,"gossip") do
          Gossip.set_neigbours(first_node, [f_neighbour])
          Enum.each(task_struct, fn [x,y,z] -> Gossip.set_neigbours(y, [x, z]) end )
          Gossip.set_neigbours(last_node, [l_neighbour])
          # IO.inspect(Gossip.get(x)) end)
        else
          PushSum.set_neigbours(first_node, [f_neighbour])
          Enum.each(task_struct, fn [x,y,z] -> PushSum.set_neigbours(y, [x, z]) end )
          PushSum.set_neigbours(last_node, [l_neighbour])
          # IO.inspect(Gossip.get(x)) end)
        end
      end

      def threeDtorus_network(noOfNodes, algorithm) do
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
      
        grid_length = trunc( Float.ceil( :math.pow(noOfNodes,1/3) ) );
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

      def random2D_network(noOfNodes, algorithm) do
        # Given square has max. lenth of 1.0, so  0 <= x <= 1.0 and 0 <= y <= 1.0
        noAxisPts = ceil(:math.sqrt(noOfNodes)) # such that pow(noAxisPts, 2) >= noOfNodes
        step = 1.0/noAxisPts
        axis_pts = uniform_pts(0,step)
        # IO.inspect axis_pts
        cartesian_product = for i <- axis_pts, j <- axis_pts, do: {i, j} # returns [{x1,y1}, {x2,y2}, {x3,y3}, ......, {xn, yn}]
        shuffled = Enum.shuffle(cartesian_product)
        # IO.inspect shuffled
        
        # rand_xy = fn -> Enum.random(cartesian_product) end
        task_struct = Enum.map(1..noOfNodes, fn x -> Process.whereis(String.to_atom(Integer.to_string(x))) end)
        # positions = place_tasks(task_struct, rand_xy, MapSet.new)
        positions = for task <- task_struct,
                        task_index = Enum.find_index(task_struct, fn x -> x == task end),
                        xy = Enum.at(shuffled, task_index) do
                        [task, xy]
                    end
        # IO.inspect positions # A list of maps
        
        eucld_dist = fn ({x1,y1},{x2,y2}) -> :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2,2)) end
        for position <- positions do
          [k , v] = position
          # IO.inspect k
          neighbours = Enum.filter(positions -- [position], fn coord -> eucld_dist.(v, Enum.at(coord, 1)) <= 0.1 end)
                    |> Enum.map(fn coord -> Enum.at(coord, 0) end)
          # IO.inspect neighbours
          if String.contains?(algorithm,"gossip") do
            Gossip.set_neigbours(k, neighbours)
            # IO.inspect(Gossip.get(k))
          else
            PushSum.set_neigbours(k, neighbours)
            # IO.inspect(PushSum.get(k))
          end
        end
    
      end
    
      defp uniform_pts(nth,_step) when nth > 1.0, do: []
      defp uniform_pts(nth, step) do
        [nth] ++ uniform_pts(nth+step, step)
      end

      def honeycomb_network(noOfNodes, algorithm) do
        noAxisPts = ceil(:math.sqrt(noOfNodes)) # such that pow(noAxisPts, 2) >= noOfNodes
        cartesian_product = for i <- 0..noAxisPts, j <- 0..noAxisPts, do: {j, i} # get [{0,0}, {1,0}, {2,0}, .., {0,1}, {1,1}, ..]
        task_struct = Enum.map(1..noOfNodes, fn x -> Process.whereis(String.to_atom(Integer.to_string(x))) end)
    
        positions = for task <- task_struct,
                        task_index = Enum.find_index(task_struct, fn x -> x == task end),
                        xy = Enum.at(cartesian_product, task_index) do
                        [task, xy]
                    end
    
        for position <- positions do
          [k, v] = position # k is the PID, v is its coordinate
          num = rem(elem(v,1), 4) # for cases => 0, 1, 2, 3 (row_number_modulo(4))
          neighbours = hc_neighbours(num, v, positions -- [position])
          if String.contains?(algorithm,"gossip") do
            Gossip.set_neigbours(k, neighbours)
          else
            PushSum.set_neigbours(k, neighbours)
          end
        end
      end
    
      defp hc_conds(num, {nxi,nyi}, {xi,yi}) do
        cond do
          num == 1 -> {nxi,nyi} == {xi,yi-1}
          num == 2 -> {nxi,nyi} == {xi,yi+1}
          num == 3 -> {nxi,nyi} == {xi+1,yi+1}
          num == 4 -> {nxi,nyi} == {xi-1,yi-1}
          num == 5 -> {nxi,nyi} == {xi-1,yi+1}
          num == 6 -> {nxi,nyi} == {xi+1,yi-1}
        end
      end
    
      defp hc_neighbours(num, v, remaining) do
        Enum.filter(remaining, fn coord -> hc_conds(1, Enum.at(coord,1), v) end)
        ++ Enum.filter(remaining, fn coord -> hc_conds(2, Enum.at(coord,1), v) end)
        ++ Enum.filter(remaining, fn coord -> hc_conds(num+3, Enum.at(coord,1), v) end)
        |> Enum.map(fn coord -> Enum.at(coord, 0) end)
      end
    
      def hcrand_network(noOfNodes,algorithm) do
        noAxisPts =  ceil(:math.sqrt(noOfNodes))  # such that pow(noAxisPts, 2) >= noOfNodes
        cartesian_product = for i <- 0..noAxisPts, j <- 0..noAxisPts, do: {j, i} # get [{0,0}, {1,0}, {2,0}, .., {0,1}, {1,1}, ..]
        task_struct = Enum.map(1..noOfNodes, fn x -> Process.whereis(String.to_atom(Integer.to_string(x))) end)
    
        positions = for task <- task_struct,
                        task_index = Enum.find_index(task_struct, fn x -> x == task end),
                        xy = Enum.at(cartesian_product, task_index) do
                        [task, xy]
                    end
        #IO.inspect positions
    
        for position <- positions do
          [k, v] = position # k is the PID, v is its coordinate
          #IO.inspect k
          num = rem(elem(v,1), 4) # for cases => 0, 1, 2, 3 (row_number_modulo(4))
          fixed_neighbours = hc_neighbours(num, v, positions -- [position])
          neighbours = fixed_neighbours ++ [Enum.random(task_struct -- fixed_neighbours -- [k])]
          #IO.inspect neighbours
          if String.contains?(algorithm,"gossip") do
            Gossip.set_neigbours(k, neighbours)
           # IO.inspect (Gossip.get(k))
          else
            PushSum.set_neigbours(k, neighbours)
            #IO.inspect (Gossip.get(k))
          end
        end
      end

end
#end
#end