defmodule Hangman.Runtime.Server do

  @type t :: pid

  alias Hangman.Impl.Game
  use GenServer

  ### client process
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ### server process

  def init(_) do #luego del start_link se ejecuta el init, tiene que devolver el state inicial
    {:ok, Game.new_game }
  end

  def handle_call({:make_move, guess}, _from, game) do #el game es el state
    IO.inspect game
    { updated_game, tally } = Game.make_move(game, guess)
    { :reply, tally, updated_game }
  end

  def handle_call({:tally }, _from, game) do
    { :reply, Game.tally(game), game }
  end

end
