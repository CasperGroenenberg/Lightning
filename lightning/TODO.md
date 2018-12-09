TODO

<!-- 1 -->
Abstract server setup:
    from: {:ok, _} = Plug.Adapters.Cowboy.http App, []
    to: {:ok, _} = Lightning.HTTP.start(5000, App, :dev)

    ##(Port number, Module Name, environment)


<!-- 2 -->
Create Hot-loading functionality:
    Server setup specifies the environment (:dev or :prod)
    where :dev spins up a development server with hotloading.

    (see number 1: Abstract server setup)


<!-- 3 -->
Change the parse-body function to accept pattern matching:
    from:   name = Lightning.parse_body(conn).params['name']
            age = Lightning.parse_body(conn).params['age']

    to:     {name, age} = Lightning.parse_body(conn)

<!-- 4 -->
Auth Plug:
    A custom Plug middleware to authenticate a route
    example:
    
    # Route: GET "/user/:user"
    def route("GET", ["user", user], conn, res) do
        conn
        |> Lightning.Auth(user) ??
        |> res.put_resp_content_type("application/json")
        |> res.put_resp_cookie("abc", "def")