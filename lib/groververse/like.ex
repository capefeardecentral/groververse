defmodule Groververse.Like do
  use Ecto.Schema
  import Ecto.Changeset

  alias Groververse.Like

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

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end
end
