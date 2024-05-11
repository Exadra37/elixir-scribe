defmodule ElixirScribeTest do
  use ExUnit.Case
  doctest ElixirScribe

  test "greets the world" do
    assert ElixirScribe.hello() == :world
  end
end
