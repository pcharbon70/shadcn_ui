defmodule MotionMediaBudgetFixture do
  use Phoenix.Component
  use ShadcnUI

  def render(assigns) do
    entries = Jason.decode!(File.read!("demo/priv/media/fixtures.json"))["entries"]

    images =
      for n <- 1..assigns.count do
        entry = Enum.at(entries, rem(n - 1, length(entries)))

        %{
          key: "image-#{n}",
          src: "/media/" <> entry["file"],
          alt: entry["alt"],
          width: entry["width"],
          height: entry["height"],
          loading: :eager,
          href: "/media/" <> entry["file"],
          caption: "Original illustration #{n}"
        }
      end

    items =
      Enum.map(images, fn image ->
        %{
          key: image.key,
          text: image.caption,
          image: Map.take(image, [:src, :alt, :width, :height, :loading])
        }
      end)

    assigns = assign(assigns, images: images, items: items)

    ~H"""
    <!DOCTYPE html>
    <html lang="en" data-shadcn-theme="light">
      <head>
        <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>
          Fixed work budget
        </title>
      </head>
      <body>
        <main style="max-width:60rem;margin:auto">
          <h1>Fixed {@count}-item budget</h1>
          <.carousel id="budget-carousel" accessible_label="Reading">
            <:item :for={n <- 1..@count} key={"item-#{n}"} label={"Item #{n}"}>
              <a href="#end">Reading {n}</a>
            </:item>
          </.carousel>
          <.cover_flow id="budget-flow" accessible_label="Landscapes" images={@images} />
          <.image_gallery id="budget-gallery" accessible_label="Illustrations" images={@images} />
          <.marquee id="budget-marquee" accessible_label="Topics" mode={:preview} items={@items} />
          <.stagger id="budget-stagger" as={:ul} effect={:rise}>
            <:item :for={n <- 1..@count} key={"step-#{n}"}><a href="#end">Step {n}</a></:item>
          </.stagger>
          <.scroll_indicator id="budget-scroll" accessible_label="Notes" size={:small}>
            <p :for={n <- 1..@count}>
              Complete note {n}: {String.duplicate("Native content remains readable. ", 6)}
            </p>
          </.scroll_indicator>
          <a id="end" href="/examples/media-browser">Complete media browser</a>
        </main>
      </body>
    </html>
    """
  end
end

fixtures =
  for count <- [1, 8, 24], into: %{} do
    html =
      MotionMediaBudgetFixture.render(%{__changed__: nil, count: count})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()
      |> String.replace(~r/[ \t]+$/m, "")

    # Canonicalize only dynamic_tag globals, retaining all real HEEx attributes.
    html =
      Regex.replace(~r/<(div|ul|ol|li)([^<>]*)>/, html, fn full, tag, attrs ->
        if String.contains?(attrs, "data-shadcn-ui-stagger") do
          attributes =
            Regex.scan(~r/[^\s=]+(?:="[^"]*")?/, attrs) |> List.flatten() |> Enum.sort()

          "<#{tag} #{Enum.join(attributes, " ")}>"
        else
          full
        end
      end)

    {to_string(count), html}
  end

path = "test/fixtures/milestone_e_budgets.json"

if "--check" in System.argv() do
  unless Jason.decode!(File.read!(path)) == fixtures, do: raise("Budget fixture is stale")
else
  File.write!(path, Jason.encode!(fixtures, pretty: true) <> "\n")
end
