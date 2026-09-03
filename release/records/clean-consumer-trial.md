# Clean Phoenix consumer trial

`integration/clean_consumer` is a checked recipe copied into a disposable
directory outside this repository. `scripts/run-clean-consumer.mjs` places the
actual `shadcn_ui-1.0.0.tar` in a temporary signed Hex repository, configures an
isolated Hex home, and installs `shadcn_ui` by version and repository name. The
trial rejects a path dependency and requires Hex metadata in the installed
dependency, so repository source, demo modules, and developer build output
cannot satisfy the test accidentally.

The consumer compiles foundation, form, navigation, overlay, media, and motion
HEEx through `use ShadcnUI`. It renders an ordinary Plug controller response,
serves `ShadcnUI.stylesheet_path/0`, includes light and dark scopes, and checks
native dialog, link, input, region, and motion markup. It also compiles
Dstar-shaped and LiveView-shaped stateless examples. These examples describe
transport-neutral composition only; they do not add Dstar to the consumer or
claim framework/platform certification.

Run the trial after building the archive:

```console
node scripts/run-clean-consumer.mjs --archive /absolute/shadcn_ui-1.0.0.tar --output /absolute/evidence
```

No Node, npm, Tailwind, remote stylesheet, hook, or package JavaScript setup is
part of the consumer project. Node is used only by the repository-owned trial
harness to create and remove the disposable registry and consumer.
