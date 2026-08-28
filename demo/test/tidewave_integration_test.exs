defmodule ShadcnUIDemo.TidewaveIntegrationTest do
  use ExUnit.Case, async: true

  test "Tidewave is development-only and runs before the code reloader" do
    mix_project = File.read!("mix.exs")
    endpoint = File.read!("lib/shadcn_ui_demo_web/endpoint.ex")

    assert mix_project =~ ~s({:tidewave, "~> 0.6", only: :dev})

    assert endpoint =~ "  if Mix.env() == :dev do\n    plug Tidewave\n  end"

    {tidewave_position, _} = :binary.match(endpoint, "plug Tidewave")
    {reloader_position, _} = :binary.match(endpoint, "plug(Phoenix.CodeReloader)")

    assert tidewave_position < reloader_position
  end
end
