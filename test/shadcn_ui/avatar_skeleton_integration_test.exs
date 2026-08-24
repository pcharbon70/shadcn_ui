defmodule ShadcnUI.AvatarSkeletonIntegrationTest do
  use ExUnit.Case, async: false

  alias Phoenix.HTML.Safe

  # covers: shadcn_ui.foundation.avatar shadcn_ui.foundation.avatar_stack
  # covers: shadcn_ui.foundation.skeleton shadcn_ui.foundation.shared_contract

  @foundation_components %{
    ShadcnUI.Components.Foundation.Alert => :alert,
    ShadcnUI.Components.Foundation.Avatar => :avatar,
    ShadcnUI.Components.Foundation.Badge => :badge,
    ShadcnUI.Components.Foundation.Button => :button,
    ShadcnUI.Components.Foundation.Card => :card,
    ShadcnUI.Components.Foundation.Skeleton => :skeleton
  }

  defmodule ConsumerFixture do
    use Phoenix.Component
    use ShadcnUI

    def render(assigns) do
      ~H"""
      <section data-shadcn-theme="light" aria-labelledby="people-heading">
        <h2 id="people-heading">Assigned people</h2>
        <div data-avatar-stack class="sui:flex sui:max-w-full">
          <.avatar initials="P<" size={:small} stack_position={:first} data-person="one" />
          <.avatar
            initials="AK"
            image_src="/images/ak.jpg"
            image_alt="Alex Kim"
            stack_position={:middle}
            data-person="two"
          />
          <.avatar initials="+3" size={:large} stack_position={:last} data-person="more" />
        </div>
      </section>

      <section
        data-shadcn-theme="dark"
        aria-busy="true"
        aria-labelledby="loading-heading"
        data-loading-owner="application"
      >
        <h2 id="loading-heading">Loading profile</h2>
        <.card>
          <:title><.skeleton shape={:text} size={:small} /></:title>
          <div class="sui:flex sui:max-w-full sui:items-center sui:gap-3">
            <.skeleton shape={:circle} size={:large} />
            <.skeleton shape={:rectangle} size={:default} pulse={false} />
          </div>
          <:footer>
            <.badge variant={:secondary}>Caller owns replacement</.badge>
          </:footer>
        </.card>
      </section>
      """
    end
  end

  test "public imports render identity and caller-labelled loading compositions" do
    html = render_fixture()

    assert html =~ ~s(data-shadcn-theme="light")
    assert html =~ ~s(data-shadcn-theme="dark")
    assert html =~ ~s(aria-busy="true")
    assert html =~ ~s(aria-labelledby="loading-heading")
    assert html =~ ~s(data-loading-owner="application")
    assert count(html, ~r/data-shadcn-ui-slot="initials"/) == 3
    assert count(html, ~r/data-shadcn-ui-skeleton/) == 3
    assert html =~ "P&lt;"
    assert html =~ ~s(src="/images/ak.jpg")
    assert html =~ ~s(alt="Alex Kim")
    assert html =~ ~s(data-shadcn-ui-slot="initials" aria-hidden="true")
    assert count(html, ~r/aria-hidden="true"/) == 4
  end

  test "preserves dimensions, stack overlap, globals, and static loading geometry" do
    html = render_fixture()

    assert html =~ "sui:size-8"
    assert html =~ "sui:size-9"
    assert html =~ "sui:size-12"
    assert count(html, ~r/sui:-ml-2/) == 2
    assert html =~ ~s(data-person="one")
    assert html =~ ~s(data-person="two")
    assert html =~ ~s(data-person="more")
    assert html =~ "sui:h-12"
    assert html =~ "sui:w-full"
    assert count(html, ~r/data-pulse="true"/) == 2
  end

  test "all six public foundation components expose defining metadata" do
    for {module, function} <- @foundation_components do
      assert function_exported?(module, :__components__, 0)
      assert Map.has_key?(module.__components__(), function)
    end

    mix = File.read!("mix.exs")

    sources =
      Path.wildcard("lib/shadcn_ui/components/foundation/*.ex") |> Enum.map_join(&File.read!/1)

    release_files = Mix.Project.config() |> Keyword.fetch!(:package) |> Keyword.fetch!(:files)

    refute mix =~ ~r/(dstar|datastar|ash|electron|ecto|req|httpoison)/i
    refute sources =~ ~r/(Dstar|Datastar|LiveView|GenServer|Repo\.|HTTPoison|Req\.)/
    refute Enum.any?(release_files, &String.starts_with?(&1, ["test", "demo", "assets"]))
  end

  test "compiled stylesheet contains rendered classes and accessibility fallbacks" do
    html = render_fixture()
    css = File.read!(ShadcnUI.stylesheet_path())

    classes =
      ~r/class="([^"]+)"/
      |> Regex.scan(html, capture: :all_but_first)
      |> List.flatten()
      |> Enum.flat_map(&String.split/1)
      |> Enum.filter(&String.starts_with?(&1, "sui" <> ":"))
      |> Enum.uniq()

    for class <- classes do
      assert css =~ css_class(class), "compiled CSS is missing #{class}"
    end

    assert css =~ "data-shadcn-ui-skeleton"
    assert css =~ "animation:none!important"
    assert css =~ "prefers-reduced-motion:reduce"
    assert css =~ "forced-colors:active"
  end

  defp render_fixture do
    %{__changed__: nil}
    |> ConsumerFixture.render()
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp count(content, pattern), do: pattern |> Regex.scan(content) |> length()

  defp css_class(class) do
    "." <>
      (class
       |> String.replace("\\", "\\\\")
       |> String.replace(":", "\\:")
       |> String.replace(".", "\\.")
       |> String.replace("/", "\\/")
       |> String.replace("[", "\\[")
       |> String.replace("]", "\\]"))
  end
end
