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

def set_neigbours(pid, arg) do  
  GenServer.cast(pid, {:set_neigbours,arg})
end


defp schedule_work() do
  Process.send_after(self(), :work, 50)
end

def recieveRumour(pid, arg) do
  GenServer.cast(pid, {:recieveRumour,arg})
end

def handle_info(:work, %{neighbours: name, rumour: value1, counter: value2} = state) do
  # do important stuff
  #IO.puts "Important stuff in progress...work"
  #IO.puts value2
  name = Enum.filter(name, fn x -> x != nil end)
  name = Enum.filter(name, fn x -> Process.alive?(x) end)
  #IO.inspect self()
  if length(name) !=0 do
  neighbour = Enum.random(name)  #handle for empty list
  #IO.inspect self()
  #IO.inspect state
  GenServer.cast(neighbour, {:recieveRumour,value1})
  schedule_work()
  {:noreply, state}
  else
    NodeInfo.done( self() )
      {:stop, :normal, %{state | rumour: value1 , counter: value2 + 1}} 
  end
  
end

#to add neighbours to the existing list
def handle_cast({:set_neigbours,arg} ,%{neighbours: name} = state) do

  
  {:noreply,%{state | neighbours: name ++ arg}  }
  
end




def handle_cast({:recieveRumour,arg} ,%{neighbours: name, rumour: _value1, counter: value2} = state) do

    #name = Enum.filter(name, fn x -> x != nil end)
    #name = Enum.filter(name, fn x -> Process.alive?(x) end)
    if value2 == 0 do
      NodeInfo.infected( self() )
      schedule_work()
    end 
    if length(name) == 0 or value2+1 >= 10 do
     # NodeInfo.done( System.monotonic_time(:millisecond) )
     NodeInfo.done( self() )
      {:stop, :normal, %{state | rumour: arg, counter: value2 + 1}} 
    else
    #neighbour = Enum.random(name)  #handle for empty list
    #GenServer.cast(neighbour, {:recieveRumour,arg})
    
    {:noreply, %{state |  rumour: arg, counter: value2 + 1}} 
     end

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
  def start_link(n) do
    GenServer.start_link(__MODULE__, %{neighbours: [],sum: n,weight: 1,counter: 0},name: String.to_atom(Integer.to_string(n)) )
   
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
 
 def set_neigbours(pid, arg) do  
   GenServer.cast(pid, {:set_neigbours,arg})
 end
 
 def recieve_sumpair(pid, s,w) do
   GenServer.cast(pid, {:recieve_sumpair,s,w})
 end
 
 defp schedule_work() do
  Process.send_after(self(), :work, 50)
end



def handle_info(:work, %{neighbours: name, sum: s, weight: w, counter: c} = state) do
  # do important stuff
  #IO.puts "Important stuff in progress...work"
  #IO.puts s/w
  #IO.puts c
  name = Enum.filter(name, fn x -> x != nil end)
  name = Enum.filter(name, fn x -> Process.alive?(x) end)
  #IO.inspect self()
  if length(name) !=0 do
    neighbour = Enum.random(name)  #handle for empty list
    #IO.inspect self()
  #  if c > 0 do
    #IO.inspect state
   # end
    GenServer.cast(neighbour, {:recieve_sumpair,s/2, w/2})
    schedule_work()
    {:noreply,%{state | sum: s/2 , weight: w/2 , counter: c}  }

  else
    NodeInfo.done( self() )
    {:stop, :normal, %{state | sum: s , weight: w , counter: c}} 
  end
  
end


 #to add neighbours to the existing list
 def handle_cast({:set_neigbours,arg} ,%{neighbours: name} = state) do
 
   
   {:noreply,%{state | neighbours: name ++ arg}  }
   
 end
 
 
 
 #Push Sum receive and send logic
 def handle_cast({:recieve_sumpair,received_sum,received_weight} ,%{neighbours: name, sum: s, weight: w, counter: c} = state) do
 
     if w == 1 do
      NodeInfo.infected( self() )
      schedule_work()

     end 
     name = Enum.filter(name, fn x -> x != nil end) 
     name = Enum.filter(name, fn x -> Process.alive?(x) end)
     old_ratio = s/w
     s = s + received_sum
     w = w + received_weight
     new_ratio = s/w

    
      c =   compare_sw_ratio(old_ratio, new_ratio, c)
     
      if c > 0 do
       # IO.puts "hahahah"
        #IO.puts c
      end

     

     if length(name) == 0 or c >= 3 do
       NodeInfo.done(System.monotonic_time(:millisecond))
       {:stop, :normal, %{state | sum: s , weight: w , counter: c}} 
     else
     #neighbour = Enum.random(name)  #handle for empty list
     #GenServer.cast(neighbour, {:recieve_sumpair,s/2, w/2})
     #schedule_work()
     {:noreply,%{state | sum: s , weight: w , counter: c}  }

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

 def handle_call(:reset, _from, state) do
  {:reply,state, [] , 100000}
end
 
 defp compare_sw_ratio(old_ratio, new_ratio,c) do
  if abs(new_ratio - old_ratio) <= :math.pow(10,-10) do
    c+1
  else
    0
   end
end
  
  end
  
