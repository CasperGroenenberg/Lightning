defmodule App do

    require EEx
    # EEx.function_from_file :defp, :template_show_user, "templates/show_user.eex", [:user_id]
    EEx.function_from_file(:defp, :template_show_user, Path.expand("./lib/templates/show_user.eex"), [:user_id])

    use Lightning.HTTP
    
    


    def route("GET", ["json"], conn, res) do
        conn 
        |> res.put_resp_header("Server", "Plug")
         
        Lightning.HTTP.send_json(conn, res, 200, %{"age" => 27, "name" => "Devin Torres"})
    end
    

    # def route("GET", "/text/:first/:last", [first, last], conn, res) do
    def route("GET", ["text", first, last], conn, res) do
        conn 
        |> res.put_resp_header("Server", "Plug")
        |> res.put_resp_content_type("text/html")

        Lightning.HTTP.send_text(conn, res, 200, "Hello from text response " <> first <> last)
    end


    def route("POST", ["parse"], conn, res) do


        # {:ok, body, conn} = Plug.Conn.read_body(conn)
        # parsed_body = Poison.Parser.parse!(body)
        # IO.puts "The body is #{parsed_body}, #{inspect is_map(parsed_body))"

        conn = Lightning.HTTP.parse_body(conn)
        name = conn.params["name"]

        Lightning.HTTP.send_text(conn, res, 200, "Hello from text response:" <> name)
    end


    # ROUTE "/user/:id/", [id]
    # def route("GET", "user/:id", [id], conn, res) do
    
    def route("GET", ["user", user_id], conn, res) do
        conn 
        |> res.put_resp_header("Server", "Plug")
        |> res.put_resp_content_type("text/html")

        # case App.Repo.get(User, id) do
        #       nil -> Lightning.HTTP.send_text(conn, res, 404, "User with ID" <> id <> " not found, sorry")
        #       user -> Lightning.HTTP.send_eex(conn, res, 200, "templates/show_user.eex", [user: user])
        # end

        # Lightning.HTTP.send_eex(conn, res, 200, "templates/show_user.eex", [user_id: user_id])
        Lightning.HTTP.send_eex(conn, res, 200, template_show_user(user_id))
        # page_contents = EEx.eval_file("templates/show_user.eex", [user_id: user_id])

        # page_contents = template_show_user(user_id)
        # conn |> res.put_resp_content_type("text/html") |> res.send_resp(200, page_contents)      

        # Lightning.HTTP.send_text(conn, res, 200, "Hello from text response:" <> user_id)
    end



    

    def route(_method, _path, conn) do
    # this route is called if no other routes match
            conn |> Plug.Conn.send_resp(404, "Couldn't find page")
    end
end


