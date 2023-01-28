defmodule Groververse.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Groververse.Repo
  alias Groververse.Post

  schema "posts" do
    field :caption, :string
    field :tags, {:array, :string}
    field :url, :string

    timestamps()
  end

  def create_post(attrs) do
    case Post.upload_file(attrs) do
      {:ok, url} ->
        attrs = Map.put(attrs, "url", url)
        %Post{}
        |> Post.changeset(attrs)
        |> Repo.insert()
      {:error, error} -> {:error, error}
    end
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:url, :caption, :tags])
    |> validate_required([:url])
  end

  def get_post(id) do
    Repo.get!(Post, id)
  end

  def get_all_posts() do
    Repo.all(Post)
  end

  def upload_file(attrs) do
    file = attrs["file"]
    ext = Path.extname(file.filename)
    file_uuid = UUID.uuid4()
    s3_filename = "#{file_uuid}#{ext}"
    s3_bucket = "groververse"
    case File.read(file.path) do
      {:ok, file_binary} ->
        case ExAws.S3.put_object(s3_bucket, s3_filename, file_binary) |> ExAws.request do
          {:ok, _} ->
            {:ok, "https://s3.amazonaws.com/#{s3_bucket}/#{s3_filename}"}
          {:error, _} ->
            {:error, "Error uploading file"}
        end
      {:error, _} ->
        {:error, "Error reading file"}
    end
  end

end
