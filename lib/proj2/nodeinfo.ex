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
    def initiate_rumor() do
        GenServer.cast(__MODULE__, :intitiate_rumor)
    end

    def done do
       GenServer.cast(__MODULE__, :done)
      #GenServer.call(__MODULE__, :don, :infinity)
    end

    #intitate rumour for "1" process
    def handle_cast(:intitiate_rumor, {numOfNodes,start_time,_list}) do
        start_time = System.monotonic_time(:millisecond)
        Gossip.recieveRumour(Process.whereis(String.to_atom("1")), "rumor")
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
  

    def handle_call(:get,_from,{numOfNodes,start_time,list}=state) do
        #IO.puts (Enum.at(list,length(list) -1 ) - start_time)
        {:reply, state,state}
    end




end