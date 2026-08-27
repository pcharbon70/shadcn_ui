defmodule CandidateConsumer.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    body =
      CandidateConsumer.Page.render(%{}) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(
      200,
      "<!doctype html><html><head><link rel=\"stylesheet\" href=\"/assets/shadcn_ui.css\"></head><body>#{body}</body></html>"
    )
  end

  get "/assets/shadcn_ui.css" do
    conn
    |> put_resp_content_type("text/css")
    |> send_file(200, ShadcnUI.stylesheet_path())
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
