# Lightning

View the docs: https://hexdocs.pm/lightning/Lightning.html<br>

Lightning is an Elixir library for making simple REST API endpoints based on Plug



# How to get started:

Create a new file (App.ex)


```
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
    Lightning.send_json(conn, res, 200, %{"age" => 26, "name" => "Casper"})
end
```
# Running the server
Start up a server using the iex command:
```
    iex -S mix
    iex> {:ok, _} = Lightning.start(5000, App, :dev)

Navigating to localhost:4000/json will output JSON response:
{"name":"Casper","age":26}
```

# Example Code

![code example](https://i.imgur.com/hyySEfc.png)
