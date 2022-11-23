defmodule Procs do

  #podes mantener el state con llamadas recursivas a la func
  def hello(count) do
    receive do
      #spawn creates an isolated process—it is independent of the process that created it. You don't (by default) receive any notification that it has died.
      #spawn_link links the creating and created processes. If one dies an abnormal death, the other is killed.
      #Most of the time, this is the behavior we want. Without it, we'll leave zombies lying around, an we won't know that subprocesses have died.
      { :crash, reason } ->
        exit(reason)
      { :quit } ->
        IO.puts "I'm outta here"
      { :add, n } ->
        hello(count+n)
      { :reset } ->
        hello(0)
      msg ->
        IO.puts("#{count} Hello #{inspect msg}")
        hello(count)
      end
    end

  end
