defmodule Lightning.HTTP do
    # defmacro __before_compile__(_env) do
    #     quote do
    #         import unquote(Plug.Conn)

    #         @before_compile Plug.Conn
    #     end
    # end
  
    defmacro __using__(_opts) do
        quote do
        import Plug.Conn
        
            def init(options) do
                IO.puts "starting up Server... "
                IO.puts "navigate to localhost:<port> in the browser"
                options
            end

            def call(conn, _opts) do
             
                # conn.method |> Atom.to_string |> String.capitalize
                # IO.puts conn.method
                route(conn.method, conn.path_info, conn)
            end
        end
    end
end