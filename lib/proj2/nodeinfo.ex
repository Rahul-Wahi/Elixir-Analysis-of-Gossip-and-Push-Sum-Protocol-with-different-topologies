defmodule NodeInfo do 
    use GenServer

    def start_link(numOfNodes) do
        GenServer.start_link(__MODULE__, {numOfNodes,0,[]},name: __MODULE__ )
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

    def done do
       GenServer.cast(__MODULE__, :done)
      #GenServer.call(__MODULE__, :don, :infinity)
    end

    #intitate rumour for "1" process
    def handle_cast({:initiate_algorithm,algorithm}, {numOfNodes,_start_time,_list}) do
        start_time = System.monotonic_time(:millisecond)
        if String.contains?(algorithm,"gossip") do
        Gossip.recieveRumour(Process.whereis(String.to_atom("1")), "rumor")
        else
            PushSum.recieve_sumpair(Process.whereis(String.to_atom("1")), 0,0)
        end
        {:noreply, {numOfNodes,start_time,[]} }
    end

    def handle_cast(:done,{numOfNodes,start_time,list}) do
        end_time = System.monotonic_time(:millisecond)
        #if length(list) >= 0.7 * numOfNodes do
         #   Process.send_after(self(), :start, 0)
        #end

        {:noreply, {numOfNodes,start_time,list ++ [end_time]} }
    end
    def handle_info(:start, {numOfNodes,start_time,list}) do
        IO.puts (Enum.at(list,length(list) -1 ) - start_time)
       # NodeInfo.get()
       IO.puts "here"
        {:noreply, {numOfNodes,start_time,list }}
    end
  

    def handle_call(:get,_from,{_numOfNodes,_start_time,_list}=state) do
        #IO.puts (Enum.at(list,length(list) -1 ) - start_time)
        {:reply, state,state}
    end




end