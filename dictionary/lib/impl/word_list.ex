defmodule Dictionary.Impl.Word_List do

  #module atributtes -> se ejecutan al momento de compilación. Una vez sola
    #@word_list
    #|> File.read!()
    #|> String.split(~r/\n/, trim: true)

  @type t :: list(String)
  @spec start() :: t
  def start() do
    "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(t) :: String.t
  def random_word(words) do
    words
    |> Enum.random()

  end

end
