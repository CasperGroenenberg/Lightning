# Lightning

Lightning is an Elixir library for making simple REST API endpoints based on Plug

[![Hex version badge](https://img.shields.io/hexpm/v/lightning.svg)](https://hex.pm/packages/lightning)
[![Docs](https://img.shields.io/badge/docs-lightning-blue.svg)](https://hexdocs.pm/lightning/Lightning.html)



# How to get started:

Create a new file (App.ex)


```elixir
defmodule App do 
   use Lightning

 #Create a new route endpoint
 #Route: GET "/json/"
 def route("GET", ["json"], conn, res) do

    #Set additional response information (based on Plug responses)
    conn 
    |> res.put_resp_header("Hello", "World")
    |> res.put_resp_content_type("application/json")
    |> res.put_resp_cookie("abc", "def")
    |> res.put_resp_header("X-Delivered-By", "myapp")
    |> res.put_status(200)

    #Send an JSON response with a statuscode of 200:
    Lightning.send_json(conn, res, 200, %{"age" => 26, "name" => "Name"})
end
```
# Running the server
Start up a server using the iex command:
```elixir
    iex -S mix
    iex> {:ok, _} = Lightning.start(5000, App, :dev)
    
```

Navigating to localhost:5000/json will output JSON response:<br>
```{"name":"Name","age":26}```


# Example Code

![code example](https://i.imgur.com/ECc48NP.png)
