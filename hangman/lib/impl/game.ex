defmodule Hangman.Impl.Game do


  #defino una estructura que puede ser utilizada por otros módulos
  #como esto es privado, no puedo sacarlo al archivo Type
  alias Hangman.Type

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Hangman.state,
    letters: list(String.t),
    used: MapSet.t(String.t), #un mapSET porque no se tienen que repetir las letras
  }


  defstruct( #para predefinir una lista de keys y prevenir que cambie en runtime. Siempre están asociadas a un módulo
            #This is a pretty big clue: structures are meant to hold the data that is processed by that module's functions.
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new(),
  )

  #You can use __MODULE__ as a convenient way to reference the current module name.

  @spec new_game() :: t
  def new_game do
    #%__MODULE__{
      #letters: Dictionary.random_word |> String.codepoints
    #}
    new_game(Dictionary.random_word)
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    }
  end

  ###########################################

  @spec make_move(t, String.t) :: {t, Type.tally}
  # def make_move(game = %{game_state: :won }, _guess) do
  #   { game, tally(game) }
  # end

  # def make_move(game = %{game_state: :lost }, _guess) do
  #   { game, tally(game) }
  # end

  #reemplazo los de arriba por el when cuando es :won o :lost
  def make_move(game = %{game_state: state }, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    #pregunto si la letra ya fue usada
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  ###########################################

  defp accept_guess(game, _guess, _already_used = true) do #no hace nada, pero me sirve para identicar que CU
    %{game | game_state: :already_used }
  end

  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess) )
  end

  ###########################################

  defp score_guess(game, _good_guess=true) do
    # guessed all leterres= -> :won | :good_guess
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used)) #me fijo si ganó. Comparo las usadas con las de la palabra. checkeo si es un subset de otro
    %{ game | game_state: new_state }
  end

  defp score_guess( game = %{turns_left: 1}, _bad_guess) do
    # guessed all leterres= -> :lost | dev turns_left, :bad_guess
    %{ game | game_state: :lost , turns_left: 0}
  end

  defp score_guess(game, _bad_guess) do
    # guessed all leterres= -> :lost | dev turns_left, :bad_guess
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end

  ###########################################

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort
    }
  end

  defp return_with_tally(game) do
    { game, tally(game)}
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)

  end

  defp maybe_won(true), do: :won
  defp maybe_won(_),    do: :good_guess

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_,    _letter), do: "_"
end
