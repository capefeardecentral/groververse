# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Groververse.Repo.insert!(%Groververse.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# create admin user
Groververse.Accounts.register_user(%{
  email: "admin@test.com",
  password: "password",
  username: "admin",
  is_admin: true})