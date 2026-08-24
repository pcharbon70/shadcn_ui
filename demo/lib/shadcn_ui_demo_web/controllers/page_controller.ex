defmodule ShadcnUIDemoWeb.PageController do
  use ShadcnUIDemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
