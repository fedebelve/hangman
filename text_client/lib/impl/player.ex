defmodule TextClient.Impl.Player do

  @type tally :: Hangman.Type.tally()
  @typep game :: Hangman.game()
  @typep state :: {game, tally}

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact({ game, tally })
  end


  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts "You Won!"
  end

  def interact({game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... the word was #{game.letters |> Enum.join()}")
  end

  # def interact({game, tally}) do
  #   #feedback
  #   IO.puts feedback_for(tally)
  #   #display
  #   IO.puts current_word(tally)
  #   #get next guess
  #   guess = get_guess()
  #   #make move
  #   { updated_game, updated_tally } = Hangman.make_move(game, guess)
  #   |> interact({ updated_game, updated_tally })
  # end

  def interact({ game, tally }) do
    IO.puts feedback_for(tally)
    IO.puts(current_word(tally))
    tally = Hangman.make_move(game, get_guess())
    interact({ game, tally })
  end

  def feedback_for(tally = %{game_state: :initializing }) do
    "Welcome! I'm thing of a #{ tally.letters |> length} letter word"
  end

  def feedback_for(tally = %{game_state: :good_guess }) do
    "Good Guess!"
  end

  def feedback_for(%{ game_state: :bad_guess}), do: "Sorry, that letter's not in the word"
  def feedback_for(%{ game_state: :already_used}), do: "Sorry, that letter's already used"

  def current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      "   turns left: ",
      tally.turns_left |> to_string,
      "   used so far: ",
      tally.used |> Enum.join(",")
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
