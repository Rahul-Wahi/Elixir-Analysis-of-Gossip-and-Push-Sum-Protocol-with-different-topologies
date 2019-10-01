defmodule NodeInfo do 
    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__, {0,0, []},name: __MODULE__ )
    end
    def init(state) do
       {:ok, state}
    end

    def get() do  
        GenServer.call(__MODULE__, :get, :infinity)
      end
    def initiate_algorithm(algorithm) do
        GenServer.cast(__MODULE__, {:initiate_algorithm,algorithm})
    end

    def done(end_time) do
       #
       GenServer.cast(__MODULE__, {:done,end_time})
      #GenServer.call(__MODULE__, {:done,end_time})
    end

    def infected(pid) do
        #
        GenServer.cast(__MODULE__, {:infected,pid})
       #GenServer.call(__MODULE__, {:done,end_time})
     end

    defp schedule_work() do
        Process.send_after(self(), :convergence, 50)
      end
      
      
      
      def handle_info(:convergence, {end_time,start_time, list_of_infectedNodes} ) do
        # do important stuff
        #IO.puts "Important1 stuff in progress...11"
       # IO.inspect list_of_infectedNodes
        list_of_infectedNodes = Enum.filter(list_of_infectedNodes, fn x -> Process.alive?(x) end)
        if length(list_of_infectedNodes) == 0  do
            end_time = System.monotonic_time(:millisecond)
            #IO.puts end_time
            {:noreply, {end_time,start_time, list_of_infectedNodes}}
        else
            
            #IO.puts length(list_of_infectedNodes)
            #IO.inspect list_of_infectedNodes
            #IO.inspect Gossip.get(Enum.at(list_of_infectedNodes,0))
        schedule_work()
        {:noreply, {end_time,start_time, list_of_infectedNodes}}
        end
        
      end
    #intitate rumour for "1" process
    def handle_cast({:initiate_algorithm,algorithm}, {end_time,_start_time, list_of_infectedNodes}) do
        start_time = System.monotonic_time(:millisecond)
        if String.contains?(algorithm,"gossip") do
        Gossip.recieveRumour(Process.whereis(String.to_atom("1")), "rumor")
        
        else
            PushSum.recieve_sumpair(Process.whereis(String.to_atom("1")), 0,0)
        end
        {:noreply, {end_time,start_time,list_of_infectedNodes} }
    end

    def handle_cast({:done,pid},{old_end_time,start_time, list_of_infectedNodes}) do
       
        #IO.puts (end_time - start_time)
        List.delete(list_of_infectedNodes, pid)
        schedule_work()
        {:noreply, {old_end_time,start_time, list_of_infectedNodes} }
    end


    def handle_cast({:infected,pid},{end_time,start_time, list_of_infectedNodes}) do
       
        #IO.puts (end_time - start_time)
        
        list_of_infectedNodes = list_of_infectedNodes ++ [pid]
        {:noreply, {end_time,start_time , list_of_infectedNodes } }
    end
    
    #def handle_call({:done,end_time}, _from, {end_time,start_time}=state) do
       
     #   IO.puts (end_time - start_time)
    #    {:reply, state,state}
   # end
  
    def handle_call(:get,_from,state) do
        #IO.puts (Enum.at(list,length(list) -1 ) - start_time)
        {:reply, state,state}
    end

   S



end