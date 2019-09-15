defmodule Gossip  do 
use GenServer

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
  
