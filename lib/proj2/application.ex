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
    
      
          {:ok, pid} =   MySupervisor.start_link([100,"gossip"])

    mapChildren()
    IO.inspect (pid)
    {:ok, pid}
    
  end
  
  defp mapChildren() do
    task_struct = Enum.map( 1 ..100 , fn x->  Process.whereis(String.to_atom(Integer.to_string(x))) end)

  IO.puts("r")
  IO.inspect (task_struct)

  end
end
