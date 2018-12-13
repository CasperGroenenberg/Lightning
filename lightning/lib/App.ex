defmodule App do
    use Lightning.HTTP
    use Lightning.Annotations, [:name]
    import Lightning


    @name :index
    def route("POST", ["index"], conn, res) do
        conn
        |> res.put_resp_header("Header", "Here")
        |> res.put_resp_cookie("abc", "def")

        json(conn, 200, %{"hello" => "world"})
        # |> redirect("test/new")
    end

    @name :test
    def route("GET", ["test", "new"], conn, res) do
        conn
        |> res.put_resp_header("Header", "Here")

        text(conn, 200, "TESTING")
    end

    
end
