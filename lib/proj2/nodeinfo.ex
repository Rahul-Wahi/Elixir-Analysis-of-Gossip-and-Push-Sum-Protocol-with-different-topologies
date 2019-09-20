defmodule NodeInfo do 
    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__, {0,0},name: __MODULE__ )
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

    #intitate rumour for "1" process
    def handle_cast({:initiate_algorithm,algorithm}, {end_time,_start_time}) do
        start_time = System.monotonic_time(:millisecond)
        if String.contains?(algorithm,"gossip") do
        Gossip.recieveRumour(Process.whereis(String.to_atom("1")), "rumor")
        
        else
            PushSum.recieve_sumpair(Process.whereis(String.to_atom("1")), 0,0)
        end
        {:noreply, {end_time,start_time} }
    end

    def handle_cast({:done,end_time},{_old_end_time,start_time}) do
       
        #IO.puts (end_time - start_time)
        {:noreply, {end_time,start_time} }
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