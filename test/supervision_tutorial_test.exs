defmodule SupervisionTutorialTest do
  use ExUnit.Case
  doctest SupervisionTutorial

  test "greets the world" do
    assert SupervisionTutorial.hello() == :world
  end
end
