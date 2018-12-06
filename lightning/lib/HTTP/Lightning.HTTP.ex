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
        IO.puts options
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

      Lightning.HTTP.send_text(conn, res, status, body)

  """
    def send_text(conn, res, status, body) do
        conn |> res.send_resp(status, body)
    end


  @doc """
  JSON Response.

  ## return a JSON response

      Lightning.HTTP.send_json(conn, res, status, json)

  """
    def send_json(conn, res, status, body) do
        resp_body = body |> Poison.encode!()

        conn |> res.send_resp(status, resp_body)
    end


     def parse_body(conn, opts \\ []) do
        opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])
        Plug.Parsers.call(conn, Plug.Parsers.init(opts))
    end


    def parse_json(conn, res, status, body) do
        IO.puts "parsing JSON"

        conn |> res.send_resp(status, body)
    end
end