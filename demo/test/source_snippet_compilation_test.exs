defmodule ShadcnUIDemo.SourceSnippetCompilationTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  use ShadcnUI

  alias ShadcnUIDemo.DocumentationCatalogue

  @compiled_identities (for entry <- DocumentationCatalogue.entries() do
                          ast =
                            Phoenix.LiveView.TagEngine.compile(
                              entry.documentation.source,
                              caller: __ENV__,
                              file: "catalogue:#{entry.route}",
                              line: 1,
                              tag_handler: Phoenix.LiveView.HTMLEngine
                            )

                          def compile_checked_source(unquote(entry.render), assigns),
                            do: unquote(ast)

                          {entry.render, entry.public.function,
                           entry.examples |> hd() |> Map.fetch!(:source_id)}
                        end)

  # covers: shadcn_ui.documentation_catalogue.stable_examples

  test "every exact displayed snippet compiles through the public ShadcnUI imports" do
    expected =
      Enum.map(DocumentationCatalogue.entries(), fn entry ->
        assert entry.documentation.source =~ "<.#{entry.public.function}"
        assert hd(entry.examples).source_id == "reference:#{entry.render}"
        {entry.render, entry.public.function, hd(entry.examples).source_id}
      end)

    assert @compiled_identities == expected
    assert function_exported?(__MODULE__, :__info__, 1)
    assert compile_checked_source(:unknown, %{}) == :unknown
  end

  # The clauses above are compile-time evidence. They are intentionally not
  # rendered because several snippets demonstrate caller-owned assigns.
  def compile_checked_source(_identity, _assigns), do: :unknown
end
