defmodule GoogleSpannerTest do
  use ExUnit.Case
  doctest GoogleSpanner

  test "greets the world" do
    assert GoogleSpanner.hello() == :world
  end
end
