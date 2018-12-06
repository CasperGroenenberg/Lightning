defmodule Lightning.HTTP do
 @moduledoc """
  Documentation for Lightning HTTP Module.
  """

  @doc """
  Start a server.

  ## Start up the REST server

      iex -S mix
      iex> {:ok, _} = Plug.Adapters.Cowboy.http My_App, []
      
      locate to localhost:4000 in the browser

  """
  defmacro __using__(_opts) do
    quote do
      def init(options) do
        IO.puts "starting up Server"
        options
      end

      def call(conn, _opts) do
          res = Plug.Conn
          
        route(conn.method, conn.path_info, conn, res)
      end
    end
  end


  @doc """
  Text Response.

  ## return a text response

      Lightning.HTTP.text(conn, res, status, body)

  """
    def text(conn, res, status, body) do
        conn |> res.send_resp(status, body)
    end


  @doc """
  JSON Response.

  ## return a JSON response

      Lightning.HTTP.json(conn, res, status, json)

  """
    def send_json(conn, res, status, body) do
        resp_body = body |> Poison.encode!()

        conn |> res.send_resp(status, resp_body)
    end

    def parse_json(conn, res, status, body) do
        IO.puts "parsing JSON"

        conn |> res.send_resp(status, body)
    end
end