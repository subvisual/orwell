defmodule Orwell.Factory do
  use ExMachina.Ecto, repo: Orwell.Repo

  alias Orwell.User

  def user_factory do
    %User{
      name: "Frank Herbert",
      github_uid: sequence(:github_uid, &(&1))
    }
  end
end
