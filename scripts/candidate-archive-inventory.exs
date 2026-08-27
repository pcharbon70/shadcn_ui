archive = "shadcn_ui-#{Mix.Project.config()[:version]}.tar"
output = System.argv() |> List.first() || Mix.raise("output path is required")
{:ok, outer} = :erl_tar.extract(String.to_charlist(archive), [:memory])
{_, contents} = List.keyfind(outer, ~c"contents.tar.gz", 0)
{:ok, files} = :erl_tar.extract({:binary, contents}, [:compressed, :memory])

inventory =
  files
  |> Enum.map(fn {path, bytes} ->
    {List.to_string(path), :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)}
  end)
  |> Enum.sort()
  |> Map.new()

File.write!(output, Jason.encode_to_iodata!(inventory, pretty: true))
