defmodule App do
    use Lightning.HTTP


    def route("GET", ["json"], conn, res) do
        conn 
        |> res.put_resp_header("Server", "Plug")
         
        Lightning.HTTP.send_json(conn, res, 200, %{"age" => 27, "name" => "Devin Torres"})
    end
    

    def route("GET", ["text"], conn, res) do
        conn 
        |> res.put_resp_header("Server", "Plug")

        Lightning.HTTP.send_text(conn, res, 200, "Hello from text response")
    end


    def route("POST", ["parse"], conn, res) do


        # name = conn.params["name"]
        # age = conn.params["age"]
        # IO.puts name
        # IO.puts age
        # {:ok, body, conn} = Plug.Conn.read_body(conn)

        # {:ok, body, conn} = Plug.Conn.read_body(conn)
        # parsed_body = Poison.Parser.parse!(body)
        # IO.puts "The body is #{parsed_body}, #{inspect is_map(parsed_body))"
        

        conn = Lightning.HTTP.parse_body(conn)
        name = conn.params["name"]

        
        Lightning.HTTP.send_text(conn, res, 200, "Hello from text response" <> name)
    end


    

    def route(_method, _path, conn) do
    # this route is called if no other routes match
            conn |> Plug.Conn.send_resp(404, "Couldn't find page")
    end
end


