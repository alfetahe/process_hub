defmodule Test.Service.RingTest do
  alias ProcessHub.Service.Ring
  alias :hash_ring, as: HashRing

  use ExUnit.Case

  setup do
    Test.Helper.SetupHelper.setup_base(%{}, :ring_test)
  end

  test "get ring", %{hub_id: hub_id} = _context do
    {key, type, _} = Ring.get_ring(hub_id)

    assert key === :hash_ring
    assert type === :hash_ring_static
  end

  test "add node", %{hub_id: hub_id} = _context do
    hash_ring = Ring.get_ring(hub_id)
    assert HashRing.get_node_count(hash_ring) === 1
    hash_ring = Ring.add_node(hash_ring, :node)
    assert HashRing.get_node_count(hash_ring) === 2

    assert HashRing.get_nodes(hash_ring) === %{
             "ex_unit@127.0.0.1":
               {:hash_ring_node, :"ex_unit@127.0.0.1", :"ex_unit@127.0.0.1", 1},
             node: {:hash_ring_node, :node, :node, 1}
           }
  end

  test "remove node", %{hub_id: hub_id} = _context do
    hash_ring = Ring.get_ring(hub_id)
    hash_ring = Ring.add_node(hash_ring, :node)
    assert HashRing.get_node_count(hash_ring) === 2
    hash_ring = Ring.remove_node(hash_ring, :node)
    assert HashRing.get_node_count(hash_ring) === 1

    assert HashRing.get_nodes(hash_ring) === %{
             "ex_unit@127.0.0.1": {:hash_ring_node, :"ex_unit@127.0.0.1", :"ex_unit@127.0.0.1", 1}
           }
  end

  test "key to nodes", %{hub_id: hub_id} = _context do
    hash_ring = Ring.get_ring(hub_id)

    assert Ring.key_to_nodes(hash_ring, "key1", 1) === [:"ex_unit@127.0.0.1"]
    assert Ring.key_to_nodes(hash_ring, "key2", 1) === [:"ex_unit@127.0.0.1"]

    hash_ring =
      Ring.add_node(hash_ring, :node1)
      |> Ring.add_node(:node2)
      |> Ring.add_node(:node3)

    assert Ring.key_to_nodes(hash_ring, 5000, 1) === [:node1]
    assert Ring.key_to_nodes(hash_ring, 5000, 2) === [:node1, :node2]
    assert Ring.key_to_nodes(hash_ring, 5000, 3) === [:node1, :node2, :"ex_unit@127.0.0.1"]

    assert Ring.key_to_nodes(hash_ring, 5000, 4) === [
             :node1,
             :node2,
             :"ex_unit@127.0.0.1",
             :node3
           ]

    assert Ring.key_to_nodes(hash_ring, 5000, 4) === [
             :node1,
             :node2,
             :"ex_unit@127.0.0.1",
             :node3
           ]
  end

  test "key to node", %{hub_id: hub_id} = _context do
    hash_ring = Ring.get_ring(hub_id)

    assert Ring.key_to_node(hash_ring, "key1", 1) === :"ex_unit@127.0.0.1"
    assert Ring.key_to_node(hash_ring, "key2", 1) === :"ex_unit@127.0.0.1"

    hash_ring =
      Ring.add_node(hash_ring, :node1)
      |> Ring.add_node(:node2)
      |> Ring.add_node(:node3)

    assert Ring.key_to_node(hash_ring, 5000, 1) === :node1
    assert Ring.key_to_node(hash_ring, 5000, 2) === :node1
    assert Ring.key_to_node(hash_ring, 2000, 1) === :node2
  end
end
