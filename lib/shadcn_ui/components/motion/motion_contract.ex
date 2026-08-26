defmodule ShadcnUI.Components.Motion.MotionContract do
  @moduledoc false
  @marquee %{brief: 2500, default: 5000}
  @stagger %{quick: {150, 50}, default: {250, 75}}

  def preference!(:system), do: "system"
  def preference!(:none), do: "none"
  def preference!(_), do: raise(ArgumentError, "motion must be :system or :none")

  def marquee_duration!(preset) do
    case Map.fetch(@marquee, preset) do
      {:ok, duration} -> duration
      :error -> raise ArgumentError, "unknown finite marquee preset"
    end
  end

  # Finite render-time windows; items outside the budget are immediately visible.
  def stagger_item!(index, preset \\ :default)

  def stagger_item!(index, preset) when is_integer(index) and index >= 0 do
    case Map.fetch(@stagger, preset) do
      {:ok, {duration, interval}} ->
        delay = index * interval

        if delay + duration <= 1000,
          do: %{duration_ms: duration, delay_ms: delay, animated: true},
          else: %{duration_ms: 0, delay_ms: 0, animated: false}

      :error ->
        raise ArgumentError, "unknown stagger preset"
    end
  end

  def stagger_item!(_, _), do: raise(ArgumentError, "stagger index must be a nonnegative integer")
end
