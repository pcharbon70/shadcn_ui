defmodule ShadcnUIDemoWeb.HealthController do
  use ShadcnUIDemoWeb, :controller

  alias ShadcnUIDemo.BuildIdentity

  def show(conn, _params) do
    identity = BuildIdentity.current!()

    json(conn, %{
      "status" => "ok",
      "identity" => BuildIdentity.release_metadata(identity)
    })
  end
end
