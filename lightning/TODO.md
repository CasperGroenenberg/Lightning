# TODO


## 2. Create Hot-loading functionality:
    Server setup specifies the environment (:dev or :prod)
    where :dev spins up a development server with hotloading.

    (see number 1: Abstract server setup)


## 3. Change the parse-body function to accept pattern matching:
    from:   name = Lightning.parse_body(conn).params['name']
            age = Lightning.parse_body(conn).params['age']

    to:     {name, age} = Lightning.parse_body(conn)


## 4. Auth Plug:
    A custom Plug middleware to authenticate a route
    example:
    
    # Route: GET "/user/:user"
    def route("GET", ["user", user], conn, res) do
        conn
        |> Lightning.Auth(user) ??
        |> res.put_resp_content_type("application/json")
        |> res.put_resp_cookie("abc", "def")


## 4. Remove FunctionClauseError when visiting a route:
    Fix error:
    ** (FunctionClauseError) no function clause matching in App.route/4



#DONE

<!-- v0.1.3 (2018-12-9) -->
 ̶#̶#̶ ̶1̶.̶ ̶A̶b̶s̶t̶r̶a̶c̶t̶ ̶s̶e̶r̶v̶e̶r̶ ̶s̶e̶t̶u̶p̶:̶
̶ ̶ ̶ ̶ ̶f̶r̶o̶m̶:̶ ̶{̶:̶o̶k̶,̶ ̶_̶}̶ ̶=̶ ̶P̶l̶u̶g̶.̶A̶d̶a̶p̶t̶e̶r̶s̶.̶C̶o̶w̶b̶o̶y̶.̶h̶t̶t̶p̶ ̶A̶p̶p̶,̶ ̶[̶]̶
̶ ̶ ̶ ̶ ̶t̶o̶:̶ ̶{̶:̶o̶k̶,̶ ̶_̶}̶ ̶=̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶.̶H̶T̶T̶P̶.̶s̶t̶a̶r̶t̶(̶5̶0̶0̶0̶,̶ ̶A̶p̶p̶,̶ ̶:̶d̶e̶v̶)̶
̶
̶ ̶ ̶ ̶ ̶#̶#̶(̶P̶o̶r̶t̶ ̶n̶u̶m̶b̶e̶r̶,̶ ̶M̶o̶d̶u̶l̶e̶ ̶N̶a̶m̶e̶,̶ ̶e̶n̶v̶i̶r̶o̶n̶m̶e̶n̶t̶)̶



