# Shiny Token Auth

Shiny Token Auth makes it easy to authenticate between a remote server and a Shiny server application. This can be useful in situations where a user authenticates through a web-app, and you want to embed a Shiny application in an iframe in your website, but otherwise lock-down someone directly accessing the Shiny application.

# Setup and usage

Your remote application should generate a token each time it loads the Shiny application. That token should then be appended to the Shiny application url using the parameter `t`. For example:

```
http://some-shiny-app.example?t=some_unique_token
```

Shiny Token Auth will then check the passed `t` argument, in this case `some_unique_token` against the remote server by sending it back to the remote server at a specified callback url (covered in the next section on configuring your settings).

If the token is valid, then the Shiny Token Auth method `isValidToken` returns `TRUE`. Otherwise, it returns `FALSE`.

## Configure your settings

The `settings.json` file is a simple JSON file with two keys.

* **check_token_url** - This is the URL the token passed to your Shiny server should check against to make sure the token is valid.
* **success_value** - This is the value your remote application will provide if authentication is succesful. For example, your server might return "200" or "OK".

## Securing your Shiny application

Once you have configured your `settings.json` and setup your remote application to generate and check the validity of tokens, you can Shiny Token Auth by invoking the `isValidToken` method.

`isValidToken` takes the full URL used to access your Shiny application as an argument. The method then checks whether the passed token, demarked as `t` in the URL paremeters, is valid.

In your Shiny application, you can wrap `isValidToken` in a `reactive` method and assign it to a variable. For example:

```r
shinyServer(function(input, output, session) {
  	# determine if the user is authenticated
  	isAuth <- reactive({ isValidToken(session$clientData$url_search) })
  	
  	# the rest of your code below
}
```
You can now use the value of `isAuth` (which is either `TRUE` or `FALSE`), to determine whether your user is authenticated or not. If a user is not authenticated, you could cut off access to the datasource, or change the UI displayed in your `ui.R` file.

# Dependencies

Shiny Token Auth depends on the following libraries:

* shiny
* jsonlite
* curl