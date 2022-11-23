defmodule Hangman.Type do
  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @opaque game :: Game.t #opaque sirve para no se use fuera de este módulo una manera más de decir, no te metas acá
  @type tally :: %{
    turns_left: integer(),
    game_state: state,
    letters: list(String.t),
    used: list(String.t)
  }
end
