#este módulo es para la API, es decir, acá van a estar todas las llamdas públicas
defmodule Hangman do
  #alias Hangman.Impl.Game, as: Game
  alias Hangman.Runtime.Server
  alias Hangman.Type

  @opaque game :: Server.t #opaque sirve para no se use fuera de este módulo una manera más de decir, no te metas acá
  @type tally :: Type.tally
  @spec new_game() :: game
  #defdelegate new_game, to: Game #delego la ejecución de esa función en otro módulo
  def new_game do
    {:ok, pid } = Hangman.Runtime.Application.start_game
    pid
  end

  @spec make_move(game, String.t) :: tally
  #defdelegate make_move(game, guess), to: Game
  def make_move(game, guess) do
    GenServer.call(game, {:make_move, guess })
  end

  @spec tally(game) :: Type.tally()
  #defdelegate tally(game), to: Game
  def tally(game) do
    GenServer.call(game, {:tally})
  end

end
