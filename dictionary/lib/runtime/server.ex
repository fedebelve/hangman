defmodule Dictionary.Runtime.Server do

  @type t :: pid()
  alias Dictionary.Impl.Word_List

  #@me :fede_agent

  @me __MODULE__

  use Agent

  def start_link(_) do
    {:ok, pid} = Agent.start_link(&Word_List.start/0, name: @me) #registro el Agent con un name para que pueda referenciarlo
  end

  def random_word() do
    #if :rand.uniform < 0.33 do
    #Agent.get(@me, fn _ -> exit(:boom) end)
    #end
    Agent.get(@me, &Word_List.random_word/1)
  end

end
