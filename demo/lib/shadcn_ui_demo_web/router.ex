defmodule ShadcnUIDemoWeb.Router do
  use ShadcnUIDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, html: {ShadcnUIDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ShadcnUIDemoWeb do
    pipe_through :browser

    get "/", GalleryController, :landing
    get "/forms/:form", FormController, :show
    post "/forms/submit", FormController, :submit
    get "/components/:category", GalleryController, :category
    get "/components/:category/:component", GalleryController, :component
    get "/*path", GalleryController, :not_found
  end
end
