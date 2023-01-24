defmodule Groververse.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Groververse.Comment
  alias Groververse.Repo

  schema "post_comments" do
    field :content, :string
    field :user_id, :id
    field :post_id, :id

    timestamps()
  end

  def post_comment(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def delete_comment(attrs) do
    comment = Repo.get(Comment, attrs["id"])
    |> Repo.delete()
  end

  def get_comments_for_post(conn, %{"post_id" => post_id}) do
    comments = Repo.all(from c in Comment, where: c.post_id == ^post_id, order_by: [desc: c.inserted_at])
    comments
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
