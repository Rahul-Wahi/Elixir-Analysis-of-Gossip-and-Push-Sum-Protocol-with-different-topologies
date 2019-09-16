defmodule Gossip  do 
use GenServer

def start_link(n) do
   GenServer.start_link(__MODULE__, %{neighbours: [],rumour: "",counter: 0},name: String.to_atom(Integer.to_string(n)) )
  
end

def init(state) do
  {:ok, state}
end

def get(pid) do  
  GenServer.call(pid, :get, :infinity)
end

def set(pid) do  
  GenServer.call(pid, :set, :infinity)
end

def recieveRumour(pid, arg) do
  GenServer.cast(pid, {:recieveRumour,arg})
end

def handle_cast({:recieveRumour,arg} ,%{neighbours: name, rumour: value1, counter: value2} = state) do

    neighbour = Enum.random(name)  #handle for empty list
    GenServer.cast(neighbour, {:recieveRumour,value1})
    if value2+1 < 10 do
    {:noreply,%{state | rumour: arg, counter: value2 + 1}  }
    else
      {:stop, "", %{state | rumour: arg, counter: value2 + 1}} 
  end

end

def handle_cast({:onneighbourterminate,pid}, %{neighbours: name} = state ) do
  {:noreply,Map.put(state, :neighbours, List.delete( name, pid))  }
end

def handle_call(:get, _from, state) do
  {:reply,state, state , 100000}
end

def handle_call(:set, _from, state) do
  {:reply,state, [] , 100000}
end





# add the value to the state and returns :ok
def handle_call({:add, value},_from, %{name: name, money: money} = state) do
  {:reply, "#{value} added to #{name} ", Map.put(state, :money, money+value)}
end



end


defmodule PushSum  do 
  use GenServer
  #Code.require_file("Vam.ex")
  
  def start_link(n) do
     GenServer.start_link(__MODULE__, [],name: String.to_atom(Integer.to_string(n)) )
    
  end
  
  
  def init(state) do
    {:ok, state}
  end
  
  
  
  def get(pid) do  
    
      GenServer.call(pid, :get, :infinity)
  end
  def set(pid) do  
    
    GenServer.call(pid, :set, :infinity)
  end
  
  def handle_call(:get, _from, state) do
    
    {:reply,state, state , 100000}
  end
  
  def handle_call(:set, _from, state) do
    
    {:reply,state, [] , 100000}
  end
  

  
  
  
  end
  
