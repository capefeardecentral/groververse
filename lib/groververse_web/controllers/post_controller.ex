defmodule GroververseWeb.PostController do
  use GroververseWeb, :controller

  alias Groververse.Post
  alias Groververse.Like
  alias Groververse.Comment

  def index(conn, params) do
    changeset = Post.changeset(%Post{}, params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Post.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def like_post(conn, %{"id" => post_id}) do
    case Like.like_post(%{ "user_id" => conn.assigns.current_user.id, "post_id" => post_id }) do
      {:ok, _like} ->
        conn
        |> put_flash(:info, "Post liked")
        |> redirect(to: Routes.post_path(conn, :show, post_id))
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:info, "Error liking post")
        |> redirect(to: Routes.post_path(conn, :show, post_id))
    end
  end

  def unlike_post(conn, %{"id" => post_id}) do
    case Like.unlike_post(%{ "user_id" => conn.assigns.current_user.id, "post_id" => post_id }) do
      {:ok, _like} ->
        conn
        |> put_flash(:info, "Post unliked")
        |> redirect(to: Routes.post_path(conn, :show, post_id))
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:info, "Error unliking post")
        |> redirect(to: Routes.post_path(conn, :show, post_id))
        show(conn, %{"id" => post_id})
    end
  end

  def comment_post(conn, params) do
    post_id = params["id"]
    user_id = conn.assigns.current_user.id
    content = params["comment"]["content"]
    attrs = %{ "user_id" => user_id, "post_id" => post_id, "content" => content }
    case Comment.post_comment(attrs) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Error creating comment")
        |> redirect(to: Routes.post_path(conn, :show, post_id, comment_changeset: changeset))
    end
  end

  def show(conn, %{"id" => id}) do
    changeset = Comment.changeset(%Comment{}, %{"post_id" => id})
    post = Post.get_post(id)
    user_likes = Like.get_user_likes(conn, %{"post_id" => id})
    all_likes = Like.get_all_likes(%{"post_id" => id})
    all_comments = Comment.get_comments_for_post(%{"post_id" => id})
    render(conn, "show.html", post: post, user_likes: user_likes, all_likes: all_likes, all_comments: all_comments, comment_changeset: changeset)
  end

end