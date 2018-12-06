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

        Lightning.HTTP.text(conn, res, 200, "Hello from text response")
    end


    def route("POST", ["parse", user_id], conn, res) do
        

        Lightning.HTTP.parse_json(conn, res, 200, "Hello from text response")
    end


    

    def route(_method, _path, conn) do
    # this route is called if no other routes match
            conn |> Plug.Conn.send_resp(404, "Couldn't find page")
    end
end


