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

for component <-
      ~w(dialog alert_dialog drawer popover dropdown_actions tooltip hover_card overlay_contract supplemental_contract) do
  unless "lib/shadcn_ui/components/overlays/#{component}.ex" in paths,
    do: raise("#{component} is missing from the release archive")
end

IO.puts("Release archive allowlist verified: #{length(paths)} entries")

for path <-
      ~w(lib/shadcn_ui/components/motion/scroll_indicator.ex lib/shadcn_ui/components/media/cover_flow.ex lib/shadcn_ui/components/motion/marquee.ex lib/shadcn_ui/components/motion/stagger.ex lib/shadcn_ui/components/media/carousel.ex lib/shadcn_ui/components/media/media_contract.ex lib/shadcn_ui/components/motion/motion_contract.ex priv/compatibility/motion_media.json priv/compatibility/motion_media.schema.json) do
  unless path in paths, do: raise("Missing motion/media foundation: #{path}")
end

if Enum.any?(
     paths,
     &String.contains?(&1, [
       "fixtures.json",
       "motion_media_evidence",
       "scroll_media_evidence",
       "/media/ridge.svg"
     ])
   ),
   do: raise("Demo media/evidence leaked into release")
