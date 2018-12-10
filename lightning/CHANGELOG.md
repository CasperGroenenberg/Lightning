# Changelog

## v0.1.3 (2018-12-9)

	* v0.1.3 API CHANGES
		* Created abstraction (Lightning.start) for server startup<br>
			FROM: {:ok, _} = Plug.Adapters.Cowboy.http App, []<br>
			TO:   {:ok, _} = Lightning.start(5000, App, :dev)

## v0.1.2 (2018-12-9)

	* v0.1.2 API CHANGES
		* Changed ambiguous naming of module Lightning.HTTP to Lightning<br>
			FROM: use Lightning.HTTP<br>
			TO:   use Lightning

	* Updated docs to reflect name changes
	* Added TODO file

## v0.1.1 (2018-12-7)

	* Updated docs
	* fixed errors in docs
	* Added logo

## v0.1.0 (2018-12-7)

	  * First release
