defmodule Lightning do
  @moduledoc """
  Documentation for Lightning.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lightning.hello
      :world

  """
  use Router


  def route("GET", ["hello"], conn) do
    conn |> Plug.Conn.send_resp(200, "Hello from route /hello")
  end

  def route("GET", ["user", user_id], conn) do
    conn |> Plug.Conn.send_resp(200, "Requested the user with id #{user_id}")
  end

  def route(_method, _path, conn) do
    # this route is called if no other routes match
    conn |> Plug.Conn.send_resp(404, "Couldn't find page")
  end
end
