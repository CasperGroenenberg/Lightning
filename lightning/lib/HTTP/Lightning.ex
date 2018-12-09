defmodule Lightning do
    require EEx

    @moduledoc """

    Lightning is a library for making simple fast REST API endpoints based on Plug
    WARNING: API subject to change in future 0.x versions

    ## How to get started:

        Create a new file (App.ex)

        defmodule App do

        # Use the Lightning library
        use Lightning
   
        # Create a new route endpoint:
        # Route: GET "/json/"
        def route("GET", ["json"], conn, res) do

            # Set additional response information (based on Plug responses):
            conn 
            |> res.put_resp_header("Header", "Here")
            |> res.put_resp_content_type("application/json")
            |> res.put_resp_cookie("abc", "def")
            |> res.put_status(200)
            
            # Send an JSON response with a statuscode of 200:
            Lightning.send_json(conn, res, 200, %{"age" => 26, "name" => "Casper"})
        end


        -----------------------------------------
        Start up a server using the iex command:
            iex -S mix
            iex> {:ok, _} = Lightning.start(5000, App)

        # Navigating to localhost:5000/json will output JSON response:
        # {"name":"Casper","age":26}

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
    Start the server.

    ## Start up the server

        EXAMPLE:

        Lightning.start(<port>, <module_name>, <environment>)

        iex -S mix
        iex> {:ok, _} = Lightning.start(5000, App, :dev)
        
        # Locate to localhost:5000/ in the browser

    """
    def start(port, module, environment \\ :dev) do
        {:ok, _} = Plug.Adapters.Cowboy.http(module, [], port: port)
    end




    @doc """
    Text Response.

    ## return a text response

        EXAMPLE:

        # Route: GET "/hello/:firstname/:lastname/"
         def route("GET", ["hello", firstname, lastname], conn, res) do

            # Set additional response information:
            conn 
            |> res.put_resp_header("Header", "Here")
            |> res.put_resp_content_type("text/html")

            # Send an text response with a statuscode of 200:
            Lightning.send_text(conn, res, 200, "Hello from text response " <> firstname <> lastname)
        end

    """
    def send_text(conn, res, status, body) do
        conn |> res.send_resp(status, body)
    end



    @doc """
    JSON Response.

    ## return a JSON response

        EXAMPLE:

        # Route: GET "/json/"
        def route("GET", ["json"], conn, res) do

            # Set additional response information:
            conn 
            |> res.put_resp_header("Header", "Here")
            |> res.put_resp_content_type("application/json")

            # Send an JSON response with a statuscode of 200:
            Lightning.send_json(conn, res, 200, %{"age" => 26, "name" => "Casper"})
        end

    """
    def send_json(conn, res, status, body) do
        resp_body = body |> Poison.encode!()

        conn |> res.send_resp(status, resp_body)
    end



    @doc """
    EEx file response.

    ## return an EEx response

        EXAMPLE:

        # Route: GET "/user/:user_id/"
        def route("GET", ["user", user_id], conn, res) do

            # Set additional response information
            conn 
            |> res.put_resp_header("Header", "Here")
            |> res.put_resp_content_type("text/html")

            # Example using Ecto, returning different responses based on condition:
            case App.Repo.get(User, user_id) do
                nil 
                    -> Lightning.send_text(conn, res, 404, "User with ID " <> user_id <> " not found")
                user 
                    -> Lightning.send_eex(conn, res, 200, Path.expand("./lib/templates/show_user.eex"), [user: user, user_id: user_id])
            end
        end


        ---------------------------------------------
        Alternatively you can pre-compile EEx files (faster).
        # place at top of App.ex file:

        defmodule App do
            require EEx
            EEx.function_from_file(:def, :template_show_user, Path.expand("./lib/templates/show_user.eex"), [:user, :user_id])

        # and now use its pre-compiled version passing in the user and user_id as arguments:
        Lightning.send_eex(conn, res, 200, template_show_user(user, user_id)) #
        
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

    ## Parse incoming requests

        EXAMPLE:

        # Route: POST "/parse?name=casper"
        def route("POST", ["parse"], conn, res) do

            # Set additional response information:
            conn 
            |> res.put_resp_content_type("text/html")
            |> res.put_resp_cookie("abc", "def")

            # Parse the body and get value of key 'name'
            name = Lightning.parse_body(conn).params["name"]

            # Return a text response with status code 200, and "Hello <name>" as response
            Lightning.send_text(conn, res, 200, "Hello " <> name)
        end

    """
     def parse_body(conn, opts \\ []) do
        opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])
        Plug.Parsers.call(conn, Plug.Parsers.init(opts))
    end


    #TODO
    def parse_json(conn, res, status, body) do
        IO.puts "parsing JSON"

        conn |> res.send_resp(status, body)
    end
end