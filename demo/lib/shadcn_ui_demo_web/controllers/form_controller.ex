defmodule ShadcnUIDemoWeb.FormController do
  use ShadcnUIDemoWeb, :controller

  @forms %{
    "sign-in" => %{kind: :sign_in, title: "Sign in"},
    "profile" => %{kind: :profile, title: "Profile"},
    "settings" => %{kind: :settings, title: "Settings"}
  }
  @allowed ~w(account alerts contact country email features kind name notes password remember volume)

  def show(conn, %{"form" => form} = params) do
    case Map.fetch(@forms, form) do
      {:ok, page} ->
        sample = sample(form)
        render(conn, :show,
          page_title: page.title,
          page: page,
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
      render(conn, :received, page_title: "Received demonstration values", values: values)
    else
      conn |> put_status(:unprocessable_entity) |> text("Unexpected demonstration field")
    end
  end

  def submit(conn, _params), do: conn |> put_status(:unprocessable_entity) |> text("Invalid demonstration submission")

  defp normalize({key, values}) when is_list(values), do: {key, Enum.map(values, &to_string/1)}
  defp normalize({key, value}) when is_binary(value), do: {key, value}
  defp normalize({key, _value}), do: {key, "[invalid value]"}

  defp sample("sign-in"), do: %{"email" => "demo@example.test", "password" => "", "remember" => "false"}
  defp sample("profile"), do: %{"name" => "", "notes" => "Short", "country" => "ca", "contact" => "email", "volume" => "40"}
  defp sample("settings"), do: %{"alerts" => "true", "country" => "ca", "account" => "demo-001"}
end
