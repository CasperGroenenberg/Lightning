defmodule Lightning do
    require EEx

    @moduledoc """

    Lightning is a framework for making simple REST API endpoints based on Plug

    WARNING: API subject to change in future 0.x versions.<br>
    check changelog for breaking API changes: 
    <a href="https://github.com/CasperCX/Lightning/blob/master/lightning/CHANGELOG.md">CHANGELOG</a> 

    ## How to get started:

        Create a new file (App.ex)

        defmodule App do

        # Use the Lightning library
        use Lightning.HTTP
        import Lightning
   
        # New Route: GET "/helloworld/"
        def route("GET", ["helloworld"], conn) do

            # Set additional response information (based on Plug responses):
            conn 
            |> put_resp_header("Header", "Here")
            |> put_resp_content_type("application/json")
            |> put_resp_cookie("abc", "def")
            |> put_status(200)
            
            # Send an JSON response with a statuscode of 200:
            json(conn, 200, %{"hello" => "world"})
        end

        -----------------------------------------
        Start up a server using the iex command:
            iex -S mix
            iex> {:ok, _} = Lightning.start(5000, App, :dev)

        # Navigating to localhost:5000/helloworld will output JSON response:
        # {"hello":"world"}

    """

    # TODO
    # def start(port, modules, _environment \\ :dev) when is_list(modules) do
        # modules |> Enum.each(fn(mod) -> {:ok, _} = Plug.Cowboy.http(mod, [], port: port))
    # end


    @doc """
    Start the server.

    ## Start up the server

        EXAMPLE:

        Lightning.start(<port>, <module_name>, <environment>)

        iex -S mix
        iex> {:ok, _} = Lightning.start(5000, App, :dev)
        
        # Locate to localhost:5000/ in the browser

    """
    def start(port, module, _environment) do
        {:ok, _} = Plug.Cowboy.http(module, [], port: port)

        # TODO hotloading config
        # case environment do
        #     :dev -> IO.puts "start hotloading"
        # end
    end


  


    def response(conn, status, body) when is_bitstring(body) do
         conn |> Plug.Conn.send_resp(status, body)
    end


    def response(conn, status, body) when is_map(body) do
        resp_body = body |> Poison.encode!()

        conn |> Plug.Conn.send_resp(status, resp_body)
    end


    def response(conn, status, template, vars \\ []) do
        case vars do
        # Precompiled version
        [] -> conn |> Plug.Conn.send_resp(status, template)

        _  ->  page_contents = EEx.eval_file(template, vars) 
                conn |> Plug.Conn.send_resp(status, page_contents)
        end
    end




    @doc """
    Text Response.

    ## return a text response

        EXAMPLE:

        # Route: GET "/hello/:firstname/:lastname/"
         def route("GET", ["hello", firstname, lastname], conn) do

            # Set additional response information:
            conn 
            |> put_resp_header("Header", "Here")
            |> put_resp_content_type("text/html")

            # Send an text response with a statuscode of 200:
            text(conn, 200, "Hello from text response " <> firstname <> lastname)
        end

    """
    def text(conn, status, body) do
        conn |> Plug.Conn.send_resp(status, body)
        # conn |> res.send_resp(status, body)
    end



    @doc """
    JSON Response.

    ## return a JSON response

        EXAMPLE:

        # Route: GET "/json/"
        def route("GET", ["json"], conn) do

            # Set additional response information:
            conn 
            |> put_resp_header("Header", "Here")
            |> put_resp_content_type("application/json")

            # Send an JSON response with a statuscode of 200:
            json(conn, 200, %{"age" => 26, "name" => "My_name"})
        end

    """
    def json(conn, status, body) do
        resp_body = body |> Poison.encode!()

        conn |> Plug.Conn.send_resp(status, resp_body)
    end



    @doc """
    EEx file response.

    ## return an EEx response

        EXAMPLE:

        # Route: GET "/user/:user_id/"
        def route("GET", ["user", user_id], conn) do

            # Set additional response information
            conn 
            |> put_resp_header("Header", "Here")
            |> put_resp_content_type("text/html")

            # Example using Ecto, returning different responses based on condition:
            case App.Repo.get(User, user_id) do
                nil 
                    -> text(conn, 404, "User with ID " <> user_id <> " not found")
                user 
                    -> eex(conn, 200, Path.expand("./lib/templates/show_user.eex"), [user: user, user_id: user_id])
            end
        end


        ---------------------------------------------
        Alternatively you can pre-compile EEx files (faster).
        # place at top of App.ex file:

        defmodule App do
            require EEx
            EEx.function_from_file(:def, :template_show_user, Path.expand("./lib/templates/show_user.eex"), [:user, :user_id])

        # and now use its pre-compiled version passing in the user and user_id as arguments:
        eex(conn, 200, template_show_user(user, user_id)) #
        
    """
    def eex(conn, status, template, vars \\ []) do
        case vars do
            # Precompiled version
            [] -> conn |> Plug.Conn.send_resp(status, template)

            _  ->  page_contents = EEx.eval_file(template, vars) 
                    conn |> Plug.Conn.send_resp(status, page_contents)

        end   
    end



    @doc """
    Parse the incoming request body.

    ## Parse incoming request body

        EXAMPLE:

        # Route: POST "/parse?name=casper&age=26&sex=male
        def route("POST", ["parse"], conn) do

            # patternmatch the request body and get the values of first two keys and ignoring last
            [name, age, _] = parse_body(conn)

            # Return a text response with status code 200
            text(conn, 200, "Hello, name: " <> name <> " age: " <> age)
        end

    """
     def parse_body(conn, opts \\ []) do
        opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])

        # Get the values from the param keys and return as a list
        Plug.Parsers.call(conn, Plug.Parsers.init(opts)).query_params |> Map.values
    end



     @doc """
    Parse the incoming request key.

    ## Parse incoming key

        EXAMPLE:

        # Route: POST "/parse?name=casper
        def route("POST", ["parse"], conn) do

            # Request the value of key: name
            name = parse_key(conn, :name)

            # Return a text response with status code 200
            text(conn, 200, "Hello, name: " <> name)
        end

    """
    def parse_key(conn, key, opts \\ []) do
        opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])

        # Get the values from the param keys and return as a list
        Plug.Parsers.call(conn, Plug.Parsers.init(opts)).params[Atom.to_string(key)]
    end

    def redirect(conn, path_name) do
        # TODO
        # Look up if path_name is a registered route
        # lightning.Annotations.annotation

        # GOTO route url defined in annotation
        # conn |> Plug.Conn.

        case path_name do
                ["favicon.ico"] ->
                    %{conn | path_info: path_name}
                _ ->
                     %{conn | path_info: path_name}
            end
        end

         # def redirect_index(%Plug.Conn{path_info: path} = conn, _opts) do
            #     case path do
            #     [] ->
            #         %{conn | path_info: ["static", "index.html"]}

            #     ["favicon.ico"] ->
            #         %{conn | path_info: ["static", "favicon.ico"]}

            #     _ ->
            #         conn
            #     end
            # end
   


    #TODO
    def parse_json(conn, status, body) do
        IO.puts "parsing JSON"

        conn |> Plug.Conn.send_resp(status, body)
    end

end





    #    CODE SNIPPETS FOR RESEARCH

    #    use Plug.Router
        # plug Plug.Static,
        #     at: "/public",
        #     from: :my_app,
        #     only_matching: ~w(favicon)

        # defmodule HttpServer.Router do
            # use Plug.Router

            # plug(Plug.Logger)
            # plug(:redirect_index)
            # plug(:match)
            # plug(:dispatch)

            # forward("/static", to: HttpServer.StaticResources)

            # get "/sse" do
            #     # some other stuff...
            #     conn
            # end

            # match _ do
            #     send_resp(conn, 404, "not found")
            # end

            # def redirect_index(%Plug.Conn{path_info: path} = conn, _opts) do
            #     case path do
            #     [] ->
            #         %{conn | path_info: ["static", "index.html"]}

            #     ["favicon.ico"] ->
            #         %{conn | path_info: ["static", "favicon.ico"]}

            #     _ ->
            #         conn
            #     end
            # end

    # res = Plug.Conn
    # case conn.path_info do
    #         ["favicon.ico"] ->
    #             # %{conn | path_info: ["static", "favicon.ico"]}
    #             conn

    #         [] ->
    #             route(conn.method, conn.path_info, conn, res)

    #         # _ ->
    #         #     conn
    #     end
    
    
    # # case conn.path_info do
    # #     ["favicon.ico"] -> IO.puts("Favicon called")




    # use Plug.Builder
    # # use Plug.Router
    # plug(:redirect_index)

    # match _ do
    #     send_resp(conn, 404, "not found")
    # end

    # def redirect_index(conn, path_name \\ :path_name) do
    #     # case conn.path_info do
    #     # [] ->
    #     #     %{conn | path_info: [Atom.to_string(path_name)]}

    #     # ["favicon.ico"] ->
    #     #     %{conn | path_info: ["static", "favicon.ico"]}

    #     # _ ->
    #     #     conn
    #     # end

    #         %{conn | path_info: ["ya"]}
    #         # %{conn | path_info: [Atom.to_string(path_name)]}
    # end
    # def redirect(conn) do
        

    #     %{conn | path_info: ["ya"]}
    # end