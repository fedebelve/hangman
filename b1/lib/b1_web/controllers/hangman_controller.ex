defmodule B1Web.HangmanController do
  use B1Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    #put_session(conn, :game, game)  ---->
    conn = put_session(conn, :game, game)
    #render(conn, "game.html", tally: tally)
    redirect(conn, to: Routes.hangman_path(conn, :show))
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]

    put_in(conn.params["make_move"]["guess"], "")
    |> get_session(:game)
    |> Hangman.make_move(guess)
    #raise inspect(params)
    #guess = params["make_move"]["guess"]
    #game = get_session(conn, :game)
    #tally = Hangman.make_move(game, guess)
    #conn = put_in(conn.params["make_move"]["guess"], "")
    #render(conn, "game.html", tally: tally)
    redirect(conn, to: Routes.hangman_path(conn, :show))
  end

  def show(conn, _param) do
    tally =
      conn
      |> get_session(:game)
      |> Hangman.tally()
      render(conn, "game.html", tally: tally)
  end

end
