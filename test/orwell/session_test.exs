defmodule Lib.SessionTest do
  use Orwell.DataCase

  import Orwell.Factory

  alias Orwell.{Session, User}

  test "it finds an existing user" do
    uid = "herbert"
    auth = %{credentials: nil, uid: uid}
    insert(:user, %{github_uid: uid})

    assert {:ok, %User{github_uid: ^uid}} = Session.find_for_github(auth)
  end

  test "it creates a non-existing whitelisted user" do
    uid = "naps62"
    auth = %{credentials: nil, uid: uid}

    assert {:ok, %User{github_uid: ^uid}} = Session.find_for_github(auth)
  end

  test "it does not allow a non-whitelisted user" do
    uid = "nsa"
    auth = %{credentials: nil, uid: uid}

    assert {:error, _} = Session.find_for_github(auth)
  end
end
