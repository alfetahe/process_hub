defmodule ProcessHub.Strategy.Redundancy.Singularity do
  @moduledoc """
  The Singularity strategy starts a single instance of a process and creates no replicas on
  other nodes. This is the default strategy.
  """

  alias ProcessHub.Strategy.Redundancy.Base, as: RedundancyStrategy

  @typedoc """
  No options are available.
  """
  @type t() :: %__MODULE__{}
  defstruct []

  defimpl RedundancyStrategy, for: ProcessHub.Strategy.Redundancy.Singularity do
    @impl true
    @spec replication_factor(ProcessHub.Strategy.Redundancy.Singularity.t()) :: 1
    def replication_factor(_strategy), do: 1

    @impl true
    @spec master_node(struct(), ProcessHub.hub_id(), ProcessHub.child_id(), [node()]) :: node()
    def master_node(_strategy, _hub_id, _child_id, child_nodes) do
      List.first(child_nodes)
    end

    @impl true
    @spec handle_post_start(
            ProcessHub.Strategy.Redundancy.Singularity.t(),
            ProcessHub.hub_id(),
            ProcessHub.child_id(),
            pid(),
            [node()]
          ) :: :ok
    def handle_post_start(_strategy, _hub_id, _child_id, _child_pid, _hub_nodes), do: :ok

    @impl true
    @spec handle_post_update(
            ProcessHub.Strategy.Redundancy.Singularity.t(),
            ProcessHub.hub_id(),
            ProcessHub.child_id(),
            [node()],
            {:up | :down, node()},
            keyword()
          ) :: :ok
    def handle_post_update(_strategy, _hub_id, _child_id, _hub_nodes, _action_node, _opts),
      do: :ok
  end
end
