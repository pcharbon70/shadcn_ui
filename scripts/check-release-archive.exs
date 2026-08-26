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

unless "lib/shadcn_ui/components/overlays/drawer.ex" in paths,
  do: raise("Drawer is missing from the release archive")

IO.puts("Release archive allowlist verified: #{length(paths)} entries")
