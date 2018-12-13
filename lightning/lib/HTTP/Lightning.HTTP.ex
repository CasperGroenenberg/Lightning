defmodule Lightning.HTTP do
    defmacro __using__(_opts) do
        quote do
            def init(options) do
                IO.puts "starting up Server... "
                IO.puts "navigate to localhost:<port> in the browser"
                options
            end

            def call(conn, _opts) do
                res = Plug.Conn
                # conn.method |> Atom.to_string |> String.capitalize
                # IO.puts conn.method
                route(conn.method, conn.path_info, conn, res)
            end
        end
    end
end