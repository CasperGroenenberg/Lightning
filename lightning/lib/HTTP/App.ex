defmodule App do
  @moduledoc """
  Documentation for Lightning.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lightning.hello
      :world

  """
    use Lightning.HTTP
    import Lightning.HTTP.Response
    

    def route("GET", ["resp"], conn, res) do
        conn 
        |> res.put_resp_header("Server", "Plug")
         
        # conn |> res.send_resp(200, "Hello, from res.send_resp")
    
        Lightning.HTTP.Response.json(conn, res, 200, "Hello from json response")
    end
    

    def route("GET", ["hello"], conn) do
        conn |> Plug.Conn.send_resp(200, "Hello from route /hello")
    end

    def route("GET", ["user", user_id], conn) do
        conn |> Plug.Conn.send_resp(200, "Requested the user with id #{user_id}")
    end

    def route(_method, _path, conn) do
    # this route is called if no other routes match
            conn |> Plug.Conn.send_resp(404, "Couldn't find page")
    end


  

end


