defmodule ShadcnUI.Components.Overlays.OverlayContractTest do
  # Atom-count rejection evidence must run after asynchronous test modules have
  # finished loading, otherwise unrelated module compilation can change it.
  use ExUnit.Case, async: false

  alias ShadcnUI.Components.Overlays.OverlayContract

  # covers: shadcn_ui.overlay.deterministic_identity
  # covers: shadcn_ui.overlay.native_invocation
  # covers: shadcn_ui.overlay.state_ownership
  # covers: shadcn_ui.overlay.focus_ownership
  # covers: shadcn_ui.overlay.dismissal
  # covers: shadcn_ui.overlay.dom_replacement
  # covers: shadcn_ui.overlay.nesting_boundary
  # covers: shadcn_ui.overlay.web_fallback

  test "derives every relationship deterministically from explicit stable identity" do
    identity = OverlayContract.identity!("account-dialog", "security")

    assert identity == OverlayContract.identity!("account-dialog", "security")
    assert identity.base_id == "account-dialog-security"
    assert identity.invoker_id == "account-dialog-security-invoker"
    assert identity.surface_id == "account-dialog-security-surface"
    assert identity.title_id == "account-dialog-security-title"
    assert identity.description_id == "account-dialog-security-description"
    assert identity.close_id == "account-dialog-security-close"
    assert identity.initial_focus_id == "account-dialog-security-initial-focus"
    assert OverlayContract.identity!("notice", 42).surface_id == "notice-42-surface"
  end

  test "rejects blank, malformed, and request-shaped identity without atom creation" do
    for invalid <- [nil, "", "  ", "1-dialog", "dialog with spaces"] do
      assert_raise ArgumentError, ~r/overlay base ID/, fn ->
        OverlayContract.identity!(invalid)
      end
    end

    assert_raise ArgumentError, ~r/stable key/, fn ->
      OverlayContract.identity!("dialog", %{request: "value"})
    end

    before_count = :erlang.system_info(:atom_count)
    for index <- 1..250, do: OverlayContract.identity!("dialog", "request-#{index}")
    assert :erlang.system_info(:atom_count) == before_count
  end

  test "maps only closed native commands, actions, policies, modes, and placements" do
    assert OverlayContract.dialog_command!(:show_modal) == "show-modal"
    assert OverlayContract.dialog_command!(:request_close) == "request-close"
    assert OverlayContract.popover_action!(:toggle) == "toggle"
    assert OverlayContract.dismissal_policy!(:close_request) == "closerequest"
    assert OverlayContract.popover_mode!(:manual) == "manual"
    assert OverlayContract.placement!(:inline_end) == "inline-end"

    for call <- [
          fn -> OverlayContract.dialog_command!("request-value") end,
          fn -> OverlayContract.popover_action!(:open) end,
          fn -> OverlayContract.dismissal_policy!(:escape) end,
          fn -> OverlayContract.popover_mode!(:hover) end,
          fn -> OverlayContract.placement!(:center) end
        ] do
      assert_raise ArgumentError, ~r/unsupported/, call
    end
  end

  test "protects native relationships while preserving unrelated globals" do
    globals = %{
      "id" => "wrong",
      "name" => "wrong",
      "role" => "menu",
      "command" => "wrong",
      "commandfor" => "wrong",
      "popover" => "manual",
      "open" => true,
      "closedby" => "none",
      "autofocus" => false,
      "class" => "caller-class",
      "disabled" => true,
      "aria-label" => "Caller label",
      "data-state" => "pending",
      "phx-click" => "save",
      "data-on:click" => "$save()"
    }

    assert OverlayContract.protect_globals!(globals, :invoker) == %{
             "autofocus" => false,
             "popover" => "manual",
             "open" => true,
             "closedby" => "none",
             "class" => "caller-class",
             "disabled" => true,
             "aria-label" => "Caller label",
             "data-state" => "pending",
             "phx-click" => "save",
             "data-on:click" => "$save()"
           }

    refute Map.has_key?(OverlayContract.protect_globals!(globals, :dialog), "autofocus")
    refute Map.has_key?(OverlayContract.protect_globals!(globals, :popover), "popover")
  end

  test "bounds nesting to a root overlay or one Popover inside Dialog" do
    assert :ok = OverlayContract.validate_nesting!(:root, :dialog)
    assert :ok = OverlayContract.validate_nesting!(:root, :popover)
    assert :ok = OverlayContract.validate_nesting!(:dialog, :popover)

    for pair <- [{:dialog, :dialog}, {:popover, :popover}, {:popover, :dialog}] do
      assert_raise ArgumentError, ~r/only one Popover inside a Dialog/, fn ->
        apply(OverlayContract, :validate_nesting!, Tuple.to_list(pair))
      end
    end
  end

  test "source has no state process, transport, random identity, or runtime behavior" do
    source = File.read!("lib/shadcn_ui/components/overlays/overlay_contract.ex")

    refute source =~
             ~r/(LiveView|Dstar|Datastar|Electron|GenServer|Agent|Task\.|push_event|handle_event|System\.unique_integer|:rand|JavaScript)/
  end
end
