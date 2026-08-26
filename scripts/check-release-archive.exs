# Audit the actual Hex payload, not just the configured file list.
archive = "shadcn_ui-#{Mix.Project.config()[:version]}.tar"
{:ok, outer} = :erl_tar.extract(String.to_charlist(archive), [:memory])
{_, contents} = List.keyfind(outer, ~c"contents.tar.gz", 0)
{:ok, entries} = :erl_tar.table({:binary, contents}, [:compressed])
paths = Enum.map(entries, &List.to_string/1)
allowlist = Mix.Project.config()[:package][:files]

unexpected =
  Enum.reject(paths, fn path ->
    Enum.any?(allowlist, &(path == &1 or String.starts_with?(path, &1 <> "/")))
  end)

if unexpected != [], do: raise("Unexpected archive entries: #{inspect(unexpected)}")

for component <- ~w(drawer popover dropdown_actions tooltip hover_card supplemental_contract) do
  unless "lib/shadcn_ui/components/overlays/#{component}.ex" in paths,
    do: raise("#{component} is missing from the release archive")
end

IO.puts("Release archive allowlist verified: #{length(paths)} entries")
