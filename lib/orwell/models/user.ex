defmodule Orwell.User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :github_uid, :string
    field :github_info, :map
    field :github_credentials, :map
  end
end
