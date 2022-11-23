defmodule TextClient.Runtime.RemoteHangman do

  @remote_server :hangman@foxy
  def connect() do
    :rpc.call(:hangman@foxy, Hangman, :new_game, [])
  end
end
