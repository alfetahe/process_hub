defmodule Test.Service.LocalStorageTest do
  alias ProcessHub.Service.LocalStorage

  use ExUnit.Case

  setup do
    Test.Helper.SetupHelper.setup_base(%{}, :local_storage_test)
  end

  test "exists", %{hub_id: hub_id} = _context do
    assert LocalStorage.exists?(hub_id, :test) === false

    LocalStorage.insert(hub_id, :test, :test_value)

    assert LocalStorage.exists?(hub_id, :test) === true
  end

  test "insert", %{hub_id: hub_id} = _context do
    assert LocalStorage.get(hub_id, :test) === nil

    LocalStorage.insert(hub_id, :test_insert, :test_value)
    LocalStorage.insert(hub_id, :test_insert2, :test_value2, 5000)

    assert LocalStorage.get(hub_id, :test_insert) === {:test_insert, :test_value, nil}

    {key, value, ttl_timestamp} = LocalStorage.get(hub_id, :test_insert2)

    assert key === :test_insert2
    assert value === value
    assert is_number(ttl_timestamp)
  end

  test "get", %{hub_id: hub_id} = _context do
    assert LocalStorage.get(hub_id, :test) === nil

    LocalStorage.insert(hub_id, :test, :test_value)
    LocalStorage.insert(hub_id, :test2, :test_value2)

    assert LocalStorage.get(hub_id, :test) === {:test, :test_value, nil}
    assert LocalStorage.get(hub_id, :test2) === {:test2, :test_value2, nil}
  end
end
