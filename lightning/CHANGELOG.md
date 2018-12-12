# Changelog
(dd-mm-yyyy)


## v0.1.6 (12-12-2018)
	* v0.1.5 API CHANGES
```elixir
	#NEW parse_key function:
		#EXAMPLE:
			name = parse_key(conn, :name)

	#Changed architecture of core Modules
	#Using the Lightning library now requires:
		FROM: use Lightning

		TO:	  use Lightning.HTTP
			  import Lightning

	#All code does not have to be prefixed by the Lightning.* annotation
	#EXCEPT: Lightning.start(<port><module><environment>)
````

## v0.1.5 (11-12-2018)
	* v0.1.5 API CHANGES
```elixir
	#NEW pattern matching functionality for parse_body function:
		FROM: name = Lightning.parse_body(conn).params["name"]
		TO:   [name, age] = Lightning.parse_body(conn)
````

## v0.1.4 (11-12-2018)
	* Fixed critical bug that prevented the server from booting up


## v0.1.3 (9-12-2018)
	* v0.1.3 API CHANGES
```elixir
	#Created abstraction (Lightning.start) for server startup
		FROM: {:ok, _} = Plug.Adapters.Cowboy.http App, []
		TO:   {:ok, _} = Lightning.start(5000, App, :dev)
````
			

## v0.1.2 (9-12-2018)
	* v0.1.2 API CHANGES
```elixir
	#Changed ambiguous naming of module Lightning.HTTP to Lightning
		FROM: use Lightning.HTTP<br>
		TO:   use Lightning
````
	* Updated docs to reflect name changes
	* Added TODO file


## v0.1.1 (7-12-2018)
	* Updated docs
	* fixed errors in docs
	* Added logo


## v0.1.0 (7-12-2018)
	  * First release
