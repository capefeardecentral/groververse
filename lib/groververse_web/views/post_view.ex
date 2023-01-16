defmodule GroververseWeb.PostView do
  use GroververseWeb, :view

  def clean_date(date) do
    date
    |> Timex.format!("{M}/{D}/{YYYY} {h12}:{m}{AM}")
  end
end