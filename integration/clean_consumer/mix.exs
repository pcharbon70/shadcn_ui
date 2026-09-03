defmodule CandidateConsumer.MixProject do
  use Mix.Project

  def project do
    [
      app: :candidate_consumer,
      version: "0.0.0",
      elixir: "~> 1.17",
      elixirc_paths: ["lib"],
      deps: deps()
    ]
  end

  def application do
    [mod: {CandidateConsumer.Application, []}, extra_applications: [:logger]]
  end

  defp deps do
    [
      {:shadcn_ui, "== 1.0.0", repo: "candidate"},
      {:phoenix, "~> 1.8.11"},
      {:bandit, "~> 1.12"}
    ]
  end
end
