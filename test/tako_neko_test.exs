defmodule TakoNekoTest do
  use ExUnit.Case
  doctest TakoNeko

  test "greets the world" do
    assert TakoNeko.hello() == :world
  end
end
