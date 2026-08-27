defmodule CandidateConsumer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children =
      case System.get_env("CONSUMER_PORT") do
        nil -> []
        port -> [{Bandit, plug: CandidateConsumer.Router, port: String.to_integer(port)}]
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: CandidateConsumer.Supervisor)
  end
end
