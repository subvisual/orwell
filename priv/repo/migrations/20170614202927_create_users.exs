defmodule Orwell.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :github_uid, :string
      add :github_info, :map
      add :github_credentials, :map
    end
  end
end
