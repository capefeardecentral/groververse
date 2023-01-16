defmodule GroververseWeb.PostController do
  use GroververseWeb, :controller

  alias Groververse.Post
  alias Groververse.Repo

  def index(conn, _params) do
    changeset = Post.changeset(%Post{}, _params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Post.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post)
  end

end