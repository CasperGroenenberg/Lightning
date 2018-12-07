defmodule Lightning.HTTP do
    require EEx

    
    @moduledoc """
    Documentation for Lightning HTTP Module.
    """

    @doc """
    Start a server.

    ## Start up the REST server

        iex -S mix
        iex> {:ok, _} = Plug.Adapters.Cowboy.http App, []
        
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
            
            # TODO
            # Parse path info as string: example/group/1
            # conn.request_path

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

        EXAMPLE:

        def route("GET", ["json"], conn, res) do
            conn 
            |> res.put_resp_header("Server", "Plug")

            Lightning.HTTP.send_json(conn, res, 200, %{"age" => 26, "name" => "Casper Groenenberg"})
        end

    """
    def send_json(conn, res, status, body) do
        resp_body = body |> Poison.encode!()

        conn |> res.send_resp(status, resp_body)
    end



    @doc """
    Send an EEx file as response.

    ## return a EEx response

        Lightning.HTTP.send_eex(conn, res, status, template, vars)

        EXAMPLE:

        def route("GET", "user/:id", [id], conn, res) do
            conn 
            |> res.put_resp_header("Server", "Plug")
            |> res.put_resp_content_type("text/html")

            case App.Repo.get(User, id) do
                nil 
                    -> Lightning.HTTP.send_text(conn, res, 404, "User with ID" <> id <> " not found, sorry")
                user 
                    -> Lightning.HTTP.send_eex(conn, res, 200, "templates/show_user.eex", [user: user])
            end
        end
    """
    def send_eex(conn, res, status, template, vars \\ []) do
        case vars do
            # Precompiled version
            [] -> conn |> res.send_resp(status, template)

            _  ->  page_contents = EEx.eval_file(template, vars) 
                    conn |> res.send_resp(status, page_contents)

        end   
    end



    @doc """
    Parse the incoming request body.

    ## return a JSON response

        Lightning.HTTP.parse_body(conn, opts)

        EXAMPLE:

        def route("POST", ["parse"], conn, res) do

        conn = Lightning.HTTP.parse_body(conn)
        name = conn.params["name"]

        Lightning.HTTP.send_text(conn, res, 200, "Hello " <> name)
    end

    """
     def parse_body(conn, opts \\ []) do
        opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])
        Plug.Parsers.call(conn, Plug.Parsers.init(opts))
    end


    def parse_json(conn, res, status, body) do
        IO.puts "parsing JSON"

        conn |> res.send_resp(status, body)
    end
end