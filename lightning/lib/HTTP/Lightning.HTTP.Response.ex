 defmodule Lightning.HTTP.Response do
    def print(content) do
        IO.puts content
    end

    def json(conn, res, status, body) do
            conn |> res.send_resp(status, body)
    end
end

