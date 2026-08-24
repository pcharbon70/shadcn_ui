defmodule ShadcnUI.StylesheetTest do
  use ExUnit.Case, async: true

  @stylesheet Path.expand("../../priv/static/shadcn_ui.css", __DIR__)
  @source Path.expand("../../assets/shadcn_ui.css", __DIR__)

  test "distributes one nonempty canonical minified stylesheet" do
    assert File.regular?(@stylesheet)
    css = File.read!(@stylesheet)
    assert byte_size(css) > 100
    refute css =~ "\n\n"
  end

  test "pins Tailwind and its CLI in both npm manifests" do
    package = Jason.decode!(File.read!("package.json"))
    lock = Jason.decode!(File.read!("package-lock.json"))

    assert package["devDependencies"] == %{
             "@tailwindcss/cli" => "4.3.3",
             "tailwindcss" => "4.3.3"
           }

    assert lock["packages"][""]["devDependencies"] == package["devDependencies"]
    assert lock["packages"]["node_modules/tailwindcss"]["version"] == "4.3.3"
    assert lock["packages"]["node_modules/@tailwindcss/cli"]["version"] == "4.3.3"
  end

  test "uses explicit package sources and excludes Preflight" do
    source = File.read!(@source)

    assert source =~ ~s(@source "../lib/**/*.ex")
    assert source =~ ~s(@source "./**/*.css")
    assert source =~ "@import \"tailwindcss/theme.css\" prefix(sui)"
    assert source =~ "@import \"tailwindcss/utilities.css\" prefix(sui)"
    refute source =~ "preflight.css"
    refute source =~ ~s(@import "tailwindcss")
  end

  test "keeps every authored foundation selector opt-in" do
    source = File.read!(@source)
    css = File.read!(@stylesheet)

    assert source =~ "[data-shadcn-ui]"
    refute source =~ ~r/(^|\n)\s*(?:\*|html|body|button|input|select|textarea)\s*[{,]/
    refute css =~ ~r/(^|})\s*(?:\*|html|body|button|input|select|textarea)\s*[{,]/
  end

  test "contains prefixed utilities without hidden runtime assets" do
    css = File.read!(@stylesheet)

    assert css =~ ".sui\\:inline-flex"
    assert css =~ ".sui\\:h-9"
    refute css =~ ~r/\.inline-flex(?:[,{])/
    refute css =~ "--tw-"
    assert css =~ "--sui-tw-"
    refute css =~ ~r/@import\s+(?:url\()?['\"]?https?:/i
    refute css =~ ~r/url\(['\"]?https?:/i
    refute css =~ ~r/<script|javascript:/i
  end

  test "coexists with Bulma and supports a stylesheet-only consumer fixture" do
    coexistence = File.read!("test/fixtures/coexistence.html")
    consumer = File.read!("test/fixtures/stylesheet_consumer.html")

    assert coexistence =~ ~s(class="button is-primary")
    assert coexistence =~ ~s(class="sui:inline-flex sui:h-9")
    assert consumer =~ ~s(href="shadcn_ui.css")
    refute consumer =~ ~r/<script|node_modules|tailwind/i
  end
end
