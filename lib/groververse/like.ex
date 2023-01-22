defmodule Groververse.Like do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Groververse.Like
  alias Groververse.Repo

  schema "likes" do

    field :user_id, :id
    field :post_id, :id

    timestamps()
  end

  def like_post(attrs) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def unlike_post(attrs) do
    like = Repo.get_by(Like, [post_id: attrs["post_id"], user_id: attrs["user_id"]])
    |> Repo.delete()
  end

  def get_user_likes(conn, %{"post_id" => post_id}) do
    likes = Repo.get_by(Like, [post_id: post_id, user_id: conn.assigns.current_user.id])
    likes
  end

  def get_all_likes(conn, %{"post_id" => post_id}) do
    likes = Repo.one(from l in Like, where: l.post_id == ^post_id, select: count(l.id))
    likes
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end
end
