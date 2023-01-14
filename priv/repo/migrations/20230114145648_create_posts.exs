defmodule Groververse.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :url, :string
      add :caption, :string
      add :tags, {:array, :string}

      timestamps()
    end
  end
end
