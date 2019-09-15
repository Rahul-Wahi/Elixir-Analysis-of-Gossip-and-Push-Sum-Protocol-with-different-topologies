defmodule App1.Producer  do 
use GenServer
#Code.require_file("Vam.ex")

def start_link(state \\[]) do
    GenServer.start_link(__MODULE__, state , name:  __MODULE__)
end

def init(state) do
    
    {:ok, state}
end


def get() do  
    GenServer.call(__MODULE__, :get, 100000000)
end

def handle_call(:get, _from, state) do
    
  {:reply,state, state , 100000}
end

end