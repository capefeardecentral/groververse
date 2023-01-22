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
    url = Post.upload_file(attrs)
    attrs_with_url = Map.put(attrs, "url", url)

    %Post{}
    |> Post.changeset(attrs_with_url)
    |> Repo.insert()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:url, :caption, :tags])
    |> validate_required([:url])
  end

  def get_post(id) do
    post = Repo.get!(Post, id)
    post
  end

  def get_all_posts() do
    posts = Repo.all(Post)
    posts
  end

  def upload_file(attrs) do
    file = attrs["file"]
    ext = Path.extname(file.filename)
    file_uuid = UUID.uuid4()
    s3_filename = "#{file_uuid}#{ext}"
    s3_bucket = "groververse"
    {:ok, file_binary} = File.read(file.path)
    {:ok, _} = ExAws.S3.put_object(s3_bucket, s3_filename, file_binary)
               |> ExAws.request
    url = "https://s3.amazonaws.com/#{s3_bucket}/#{s3_filename}"
    url
  end

end
