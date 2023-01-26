defmodule Groververse.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Groververse.Comment
  alias Groververse.Repo
  alias Groververse.Accounts.User

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
    Repo.get(Comment, attrs["id"])
    |> Repo.delete()
  end

  def get_comments_for_post(%{"post_id" => post_id}) do
    query = from(c in Comment,
      join: u in User,
      on: c.user_id == u.id,
      where: c.post_id == ^post_id,
      order_by: [desc: c.inserted_at],
      select: %{:username => u.username, :avatar => u.avatar, :content => c.content, :inserted_at => c.inserted_at}
    )
    Repo.all(query)
#    Repo.all(query)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :user_id, :post_id])
    |> validate_required([:content, :user_id, :post_id])
  end
end
