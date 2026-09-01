defmodule ShadcnUIDemoWeb.FormController do
  use ShadcnUIDemoWeb, :controller

  alias ShadcnUIDemo.{BuildIdentity, Catalogue, GalleryPreferences}

  @forms %{
    "sign-in" => %{form_kind: :sign_in, title: "Sign in", path: "/forms/sign-in"},
    "profile" => %{form_kind: :profile, title: "Profile", path: "/forms/profile"},
    "settings" => %{form_kind: :settings, title: "Settings", path: "/forms/settings"}
  }
  @allowed ~w(account alerts contact country email features kind name notes password remember volume)

  def show(conn, %{"form" => form} = params) do
    case Map.fetch(@forms, form) do
      {:ok, page} ->
        sample = sample(form)

        render_gallery(conn, params, :show, Map.put(page, :kind, :composition),
          form: Phoenix.Component.to_form(sample, as: "demo"),
          submittable: params["static"] != "1"
        )

      :error ->
        conn |> put_status(:not_found) |> text("Demonstration form not found")
    end
  end

  def submit(conn, %{"demo" => submitted}) when is_map(submitted) do
    if Enum.all?(Map.keys(submitted), &(&1 in @allowed)) do
      values = submitted |> Enum.sort_by(&elem(&1, 0)) |> Enum.map(&normalize/1)

      page = %{
        kind: :composition,
        title: "Received demonstration values",
        path: "/components/forms"
      }

      render_gallery(conn, %{}, :received, page, values: values)
    else
      conn |> put_status(:unprocessable_entity) |> text("Unexpected demonstration field")
    end
  end

  def submit(conn, _params),
    do: conn |> put_status(:unprocessable_entity) |> text("Invalid demonstration submission")

  defp render_gallery(conn, params, template, page, assigns) do
    theme = GalleryPreferences.theme(params)
    motion = GalleryPreferences.motion(params)

    render(
      conn,
      template,
      [
        page_title: page.title,
        canonical_url:
          if(page.path in Catalogue.form_routes(),
            do: "https://leco-industries-inc.github.io/shadcn_ui" <> page.path,
            else: nil
          ),
        page: page,
        theme: theme,
        motion: motion,
        build_identity: BuildIdentity.current!(),
        categories: Catalogue.categories(),
        components: Catalogue.components()
      ] ++ assigns
    )
  end

  defp normalize({key, values}) when is_list(values), do: {key, Enum.map(values, &to_string/1)}
  defp normalize({key, value}) when is_binary(value), do: {key, value}
  defp normalize({key, _value}), do: {key, "[invalid value]"}

  defp sample("sign-in"),
    do: %{"email" => "demo@example.test", "password" => "", "remember" => "false"}

  defp sample("profile"),
    do: %{
      "name" => "",
      "notes" => "Short",
      "country" => "ca",
      "contact" => "email",
      "volume" => "40"
    }

  defp sample("settings"), do: %{"alerts" => "true", "country" => "ca", "account" => "demo-001"}
end
