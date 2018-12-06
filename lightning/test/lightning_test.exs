defmodule LightningTest do
  use ExUnit.Case
  doctest Lightning

  test "greets the world" do
    assert Lightning.hello() == :world
  end
end
