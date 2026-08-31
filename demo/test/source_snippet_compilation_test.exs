defmodule ShadcnUIDemo.SourceSnippetCompilationTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  use ShadcnUI

  alias ShadcnUIDemo.DocumentationCatalogue

  @compiled_identities (for entry <- DocumentationCatalogue.entries(),
                            example <- entry.examples do
                          ast =
                            Phoenix.LiveView.TagEngine.compile(
                              example.source,
                              caller: __ENV__,
                              file: "catalogue:#{entry.route}",
                              line: 1,
                              tag_handler: Phoenix.LiveView.HTMLEngine
                            )

                          def compile_checked_source(unquote(example.source_id), assigns),
                            do: unquote(ast)

                          {example.source_id, entry.public.function}
                        end)

  # covers: shadcn_ui.documentation_catalogue.stable_examples

  test "every exact displayed snippet compiles through the public ShadcnUI imports" do
    expected =
      for entry <- DocumentationCatalogue.entries(), example <- entry.examples do
        assert example.source =~ "<.#{entry.public.function}"
        {example.source_id, entry.public.function}
      end

    assert @compiled_identities == expected
    assert function_exported?(__MODULE__, :__info__, 1)
    assert compile_checked_source(:unknown, %{}) == :unknown
  end

  # The clauses above are compile-time evidence. They are intentionally not
  # rendered because several snippets demonstrate caller-owned assigns.
  def compile_checked_source(_identity, _assigns), do: :unknown
end
