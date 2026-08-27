defmodule CandidateConsumerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  test "actual Hex candidate renders representative public HEEx and native controls" do
    conn = CandidateConsumer.Router.call(conn(:get, "/"), [])

    assert conn.status == 200
    assert conn.resp_body =~ ~s(id="candidate-consumer")
    assert conn.resp_body =~ ~s(data-theme="light")
    assert conn.resp_body =~ ~s(data-theme="dark")
    assert conn.resp_body =~ ~s(id="save")
    assert conn.resp_body =~ ~s(name="email")
    assert conn.resp_body =~ ~s(aria-label="Primary")
    assert conn.resp_body =~ "<dialog"
    assert conn.resp_body =~ ~s(command="show-modal")
    assert conn.resp_body =~ ~s(role="region")
    assert conn.resp_body =~ ~s(aria-label="Topics")
  end

  test "serves the packaged stylesheet without package JavaScript or consumer asset tooling" do
    conn = CandidateConsumer.Router.call(conn(:get, "/assets/shadcn_ui.css"), [])
    dependency = Mix.Project.deps_paths()[:shadcn_ui]

    assert conn.status == 200
    assert conn.resp_body =~ "--shadcn-ui-background"
    assert File.regular?(ShadcnUI.stylesheet_path())
    assert File.regular?(Path.join(dependency, "hex_metadata.config"))
    refute File.exists?(Path.join(dependency, "package.json"))
    refute File.exists?(Path.join(dependency, "demo"))
    refute String.starts_with?(dependency, System.fetch_env!("CANDIDATE_SOURCE"))
  end

  test "Dstar-shaped and LiveView-shaped stateless guidance compiles without Dstar" do
    dstar =
      CandidateConsumer.DstarShapedGuidance.patch(%{})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    live =
      CandidateConsumer.LiveViewShapedGuidance.render(%{})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert dstar =~ "Server action"
    assert live =~ "Socket action"
    refute Code.ensure_loaded?(Dstar)
    assert Application.spec(:shadcn_ui, :vsn) |> to_string() == "0.1.0"
  end
end
