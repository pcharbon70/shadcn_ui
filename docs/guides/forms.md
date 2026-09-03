# Forms

Form controls preserve native labels, values, validation relationships, reset, keyboard behavior, and submission. Most controls accept either a Phoenix `field={@form[:name]}` or explicit `id`, `name`, `value`, and `errors`; the application still owns changesets, validation timing, translation, submission, and persistence. Shared states include `pending`, `required`, `optional`, and `disabled`, while `error_mode` is `used_input`, `always`, or `hidden`.

## Field

Field is a relationship-aware layout for a caller-supplied native control. It derives deterministic label, help, and error IDs from a Phoenix field or explicit identity. The required `label` and `control` slots receive the relationship contract, while `help` is optional; `describedby` can merge additional external descriptions.

```heex
<.field id="email" name="email" required>
  <:label>Email</:label>
  <:control :let={control}>
    <input id={control.id} name={control.name} aria-describedby={control.aria_describedby} />
  </:control>
  <:help>Use your work address.</:help>
</.field>
```

## Label

Label renders a native label with a protected association. Supply its own `id`, the target control's `for` ID, and visible content; `required` adds a required marker and `optional` adds an optional marker. The two states are mutually exclusive.

```heex
<.label id="email-label" for="email" required>Email</.label>
```

## Help

Help renders descriptive text for a form control. Its required `id` is intended to appear in the control's `aria-describedby` relationship; the content remains visible ordinary text.

```heex
<.help id="email-help">Use your work address.</.help>
```

## Field Errors

Field Errors renders escaped validation messages with deterministic caller-provided IDs. Pass equally sized `errors` and `ids` lists; relationship-aware controls usually create these values automatically, while the standalone component is useful for a custom control.

```heex
<.field_errors errors={["Enter an email"]} ids={["email-error-1"]} />
```

## Error Summary

Error Summary presents a form-level heading and ordered list of errors. Each error may be a plain message, a `{control_id, message}` tuple, or a `%{control_id: ..., message: ...}` map; entries with a control ID become ordinary fragment links. Focus, scrolling, and announcement policy remain application-owned.

```heex
<.error_summary
  id="errors"
  heading="Review the form"
  errors={[{"email", "Enter an email"}, "Choose a delivery method"]}
/>
```

## Input

Input renders one text-like native input inside the shared field layout. Types are `text`, `email`, `password`, `search`, `tel`, `url`, `number`, `date`, `datetime-local`, `month`, `week`, and `time`; sizes are `small`, `default`, and `large`. Native options include `readonly`, autocomplete, input mode, placeholder, length, pattern, numeric bounds, step, form, and list-related global attributes, plus optional leading, trailing, and help slots.

```heex
<.input field={@form[:email]} type="email" autocomplete="email" required>
  <:label>Email</:label>
  <:help>We will send the receipt here.</:help>
</.input>
```

## Textarea

Textarea renders a native multiline control with the shared field relationships. It accepts native rows, columns, length limits, placeholder, autocomplete, form, disabled, and readonly options. `resize` is `vertical`, `horizontal`, `both`, or `fixed`; `sizing` is `fixed` or the capability-gated `content` enhancement.

```heex
<.textarea field={@form[:notes]} rows={5} resize={:vertical} maxlength={500}>
  <:label>Notes</:label>
</.textarea>
```

## Checkbox

Checkbox renders a real checkbox with a visible label and optional help. `mode={:boolean}` submits configurable `checked_value` and `unchecked_value`, while `mode={:multiple}` submits the supplied repeated `value`; `checked` can override the rendered snapshot. It also supports the shared error and state options plus an external `form` association.

```heex
<.checkbox field={@form[:remember]} checked_value="yes" unchecked_value="no">
  <:label>Remember me</:label>
</.checkbox>
```

## Radio Group

Radio Group renders a native fieldset for one scalar choice. Supply a Phoenix field or explicit identity and a nonempty `options` list of atom-keyed maps containing unique `key`, unique string `value`, visible `label`, and optional `disabled`; set `layout` to `vertical` or `inline`. A legend is required and help is optional.

```heex
<.radio_group
  id="contact"
  name="contact"
  selected="email"
  layout={:inline}
  options={[
    %{key: "email", value: "email", label: "Email"},
    %{key: "phone", value: "phone", label: "Phone"}
  ]}
>
  <:legend>Contact method</:legend>
</.radio_group>
```

## Switch

Switch is a track-and-thumb presentation over a native boolean checkbox, suited to settings such as enabling notifications. It supports `checked_value`, `unchecked_value`, explicit `checked`, and the shared form states. `label_visibility` is `visible` or `hidden`; a hidden label requires a nonblank `accessible_label` even though the label slot remains required.

```heex
<.switch field={@form[:alerts]} label_visibility={:visible}>
  <:label>Email alerts</:label>
</.switch>
```

## Native Select

Native Select renders the platform's standard picker. Supply a nonempty list of atom-keyed option maps with `key`, `value`, `label`, and optional `disabled`; optgroup maps use `key`, `label`, nonempty `options`, and optional `disabled`. It supports single or `multiple` selection, `small`, `default`, or `large` size, shared field states, and optional help. Prompts are ordinary caller-authored options.

```heex
<.native_select
  id="country"
  name="country"
  value="ca"
  options={[
    %{key: "ca", value: "ca", label: "Canada"},
    %{key: "us", value: "us", label: "United States"}
  ]}
>
  <:label>Country</:label>
</.native_select>
```

## Enhanced Select

Enhanced Select uses the same native select value, options, validation relationships, and submission behavior as Native Select, then adds a capability-gated picker presentation. Its data shape, `multiple`, size, and shared state options are identical. Use Native Select when the dependable platform picker is preferable; unsupported browsers retain the native select.

```heex
<.enhanced_select
  id="priority"
  name="priority"
  value="normal"
  size={:large}
  options={[
    %{key: "normal", value: "normal", label: "Normal"},
    %{key: "urgent", value: "urgent", label: "Urgent"}
  ]}
>
  <:label>Priority</:label>
</.enhanced_select>
```

## Slider

Slider renders a native range input with browser-owned keyboard, reset, and form submission. Supply a Phoenix field or explicit identity and optional `min`, `max`, and `step`; shared states, help, and errors are supported. The optional `value_description` slot can explain the current value in visible text without replacing the label.

```heex
<.slider id="volume" name="volume" value={40} min={0} max={100} step={5}>
  <:label>Volume</:label>
  <:value_description>40 percent</:value_description>
</.slider>
```

## Progress

Progress represents task completion. Provide `id` and `max`; add `value` for a determinate snapshot or omit it for indeterminate progress. Sizes are `small`, `default`, and `large`, variants are `default` and `destructive`, and optional label and description slots provide visible context. If no label is rendered, provide `accessible_label`.

```heex
<.progress id="report-progress" value={4} max={10} size={:large}>
  <:label>Report generation</:label>
  <:description>Four of ten sections complete.</:description>
</.progress>
```

## Meter

Meter represents a scalar measurement within a known range, not task completion. Supply `id` and `value`, with optional `min`, `max`, `low`, `high`, and `optimum` thresholds. Sizes are `small`, `default`, and `large`; provide a label slot or `accessible_label`, and optionally a visible description.

```heex
<.meter id="storage" value={72} min={0} max={100} low={60} high={85} optimum={30}>
  <:label>Storage use</:label>
  <:description>72 GB of 100 GB used.</:description>
</.meter>
```
