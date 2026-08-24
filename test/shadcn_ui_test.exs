defmodule ShadcnUITest do
  use ExUnit.Case

  test "defines the package entry module" do
    assert Code.ensure_loaded?(ShadcnUI)
  end
end
