defmodule Groververse.Posts do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :url, :string
    field :caption, :string
    field :tags, {:array, :string}

    timestamps()
  end

  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Groververse.Repo

  alias Groververse.Posts.{Post}
  ## Database getters

  def create_post(post, attrs) do
    post
    |> cast(attrs, [:url, :caption, :tags])
    |> Repo.insert()
  end

  def get_all_posts do
    Repo.all(Post)
  end

  def get_post!(id) do
    Repo.get!(Post, id)
  end

end