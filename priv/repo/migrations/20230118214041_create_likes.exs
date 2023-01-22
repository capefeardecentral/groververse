defmodule Groververse.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:likes, [:user_id, :post_id], name: :likes_user_id_post_id_index)
    create index(:likes, [:user_id])
    create index(:likes, [:post_id])
  end
end
