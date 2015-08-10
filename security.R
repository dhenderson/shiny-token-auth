#' Parse url arguments in a Shiny session object
#' @return Returns a vector where the first argument is a
#'         token string.
parseUrlArguments <- function(url_search){
  require("shiny")
  
  # Parse the GET query string
  query <- shiny::parseQueryString(url_search)

  token <- query$t
  
  return(token)
}

isValidToken <- function(url_search){
  require("jsonlite")
  require("curl")
  
  # load the settings file
  settings <- fromJSON("settings.json")
  
  # parse the url arguments to get the token string
  token <- parseUrlArguments(url_search)
  
  # get the url to check the token against
  checkTokenUrl <- paste(settings$check_token_url, token, sep="/")
  
  # get the response
  response <- jsonlite::fromJSON(checkTokenUrl)
  status <- response$status
  
  if(status == settings$success_value){
    return(TRUE)
  }
  else{
    return(FALSE)
  }
  return(FALSE)
}


